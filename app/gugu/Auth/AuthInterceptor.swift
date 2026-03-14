import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    
    private let lock = NSLock()
    private var isRefreshing: Bool = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    // 요청 전
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let accessToken = KeychainHelper.read(key: "accessToken") else {
            DispatchQueue.main.async {
                AuthState.shared.logout()
            }
            completion(.failure(APIError.token))
            return
        }
        
        var request = urlRequest
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
    
    // 요청 실패, 재시도
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        lock.lock(); defer { lock.unlock() }
        
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }
        
        
        if response.statusCode == 403 || response.statusCode == 500 {
            DispatchQueue.main.async {
                AuthState.shared.logout()
            }
            completion(.doNotRetry)
            return
        }
        
        guard response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            isRefreshing = true
            rotateToken { [weak self] success in
                guard let self = self else { return }
                
                self.lock.lock()
                defer { self.lock.unlock() }
                
                self.requestsToRetry.forEach { $0(success ? .retry : .doNotRetry) }
                self.requestsToRetry.removeAll()
                self.isRefreshing = false
            }
        }
    }
    
    private func rotateToken(completion: @escaping (Bool) -> Void) {
        guard let accessToken = KeychainHelper.read(key: "accessToken") else {
            DispatchQueue.main.async {
                AuthState.shared.logout()
            }
            completion(false)
            return
        }
        guard let refreshToken = KeychainHelper.read(key: "refreshToken") else {
            DispatchQueue.main.async {
                AuthState.shared.logout()
            }
            completion(false)
            return
        }
        
        let url = "http://192.168.0.14:8080/api/v1/members/token"
        let params = AuthTokenRequest(accessToken: accessToken, refreshToken: refreshToken)
        print(params)
        
        AF.request(
            url,
            method: .patch,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseData { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let data):
                    if let result = try? JSONDecoder().decode(AuthTokenResponse.self, from: data) {
                        AuthState.shared.login(accessToken: result.accessToken, refreshToken: result.refreshToken)
                        completion(true)
                    } else {
                        AuthState.shared.logout()
                        completion(false)
                    }
                    
                case .failure:
                    AuthState.shared.logout()
                    completion(false)
                }
            }
        }
    }
}

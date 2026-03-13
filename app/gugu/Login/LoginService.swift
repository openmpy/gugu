import Foundation
import Alamofire

class LoginService {
    
    static let shared = LoginService()
    
    private init() {}
    
    func login(
        phone: String,
        password: String,
        completion: @escaping (Result<LoginResponse, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/login"
        let params = LoginRequest(phone: phone, password: password)
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                if let result = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(.decoding))
                }
                
            case .failure:
                if let data = response.data,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    completion(.failure(.server(message: errorResponse.message)))
                } else if response.error?.isSessionTaskError == true {
                    completion(.failure(.network))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
    }
}

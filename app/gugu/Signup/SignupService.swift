import Foundation
import Alamofire

class SignupService {
    
    static let shared = SignupService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    private init() {}
    
    func sendCode(
        phone: String,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/phone/send-code"
        let params = SignupSendCodeRequest(phone: phone)
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                completion(.success(()))
                
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
    
    func verifyCode(
        phone: String,
        code: String,
        password: String,
        gender: String,
        completion: @escaping (Result<SignupVerifyCodeResponse, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/phone/verify-code"
        let params = SignupVerifyCodeRequest(phone: phone, code: code, password: password, gender: gender)
        
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
                if let result = try? JSONDecoder().decode(SignupVerifyCodeResponse.self, from: data) {
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
    
    func activate(
        nickname: String,
        birthYear: Int,
        bio: String,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/activate"
        let params = SignupActivateRequest(nickname: nickname, birthYear: birthYear, bio: bio)
        
        session.request(
            url,
            method: .put,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                completion(.success(()))
                
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

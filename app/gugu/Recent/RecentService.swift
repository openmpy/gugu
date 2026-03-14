import Foundation
import Alamofire

class RecentService {
    
    static let shared = RecentService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    private init() {}
    
    func writeComment(
        comment: String,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/comments"
        let params = RecentWriteCommentRequest(comment: comment.isEmpty ? "반갑습니다." : comment)
        
        session.request(
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
    
    func getComments(
        gender: String,
        cursorId: Int64?,
        completion: @escaping (Result<CursorResponse<RecentGetCommentResponse>, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/comments"
        
        var params: Parameters = [
            "gender": gender,
            "size": 15
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }
        
        session.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.queryString
        )
        .validate()
        .responseDecodable(of: CursorResponse<RecentGetCommentResponse>.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                print(error)
                
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
    
    func bumpComment(
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/comments/bump"
        
        session.request(
            url,
            method: .put
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

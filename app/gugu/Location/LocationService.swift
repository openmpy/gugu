import Foundation
import Alamofire

class LocationService {
    
    static let shared = LocationService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    private init() {}
    
    func getLocations(
        gender: String,
        cursorId: Int64?,
        completion: @escaping (Result<CursorResponse<LocationGetMemberResponse>, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/locations"
        
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
        .responseDecodable(of: CursorResponse<LocationGetMemberResponse>.self) { response in
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
    
    func updateLocation(
        latitude: Double?,
        longitude: Double?,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let url = "http://192.168.0.14:8080/api/v1/members/location"
        let params = LocationUpdateMemberRequest(latitude: latitude, longitude: longitude);
        
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

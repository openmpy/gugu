import Foundation
import Alamofire

extension DataRequest {
    
    func decodingWithErrorHandling<T: Decodable>(_ type: T.Type) async throws -> T {
        let response = await self.validate().serializingDecodable(T.self).response
        
        switch response.result {
        case .success(let value):
            return value
            
        case .failure:
            if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.server(message: errorResponse.message)
            }
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    throw APIError.token
                }
            }
            if response.error?.isSessionTaskError == true {
                throw APIError.network
            }
            throw APIError.unknown
        }
    }
    
    func validateWithErrorHandling() async throws {
        let response = await self.validate().serializingData().response
        
        switch response.result {
        case .success:
            return
            
        case .failure:
            if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.server(message: errorResponse.message)
            }
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    throw APIError.token
                }
            }
            if response.error?.isSessionTaskError == true {
                throw APIError.network
            }
            throw APIError.unknown
        }
    }
}

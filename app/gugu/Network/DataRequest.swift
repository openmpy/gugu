import Foundation
import Alamofire

extension DataRequest {
    
    func decodingWithErrorHandling<T: Decodable>(_ type: T.Type) async throws -> T {
        let response = await self.serializingData().response
        
        guard let statusCode = response.response?.statusCode, let data = response.data else {
            throw APIError.network
        }
        
        if (200..<300).contains(statusCode) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decoding
            }
        }
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            throw APIError.server(message: errorResponse.message)
        }
        throw APIError.unknown
    }
}

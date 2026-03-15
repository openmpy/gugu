import Alamofire

final class MemberService {
    
    static let shared = MemberService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    // MARK: 로그인
    func login(
        phone: String,
        password: String
    ) async throws -> MemberLoginResponse {
        let url = "http://192.168.0.14:8080/api/v1/members/login"
        let params = MemberLoginRequest(phone: phone, password: password)
        
        return try await AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .decodingWithErrorHandling(MemberLoginResponse.self)
    }
    
    // MARK: 회원가입
    func sendCode(
        phone: String,
    ) async throws {
        let url = "http://192.168.0.14:8080/api/v1/members/phone/send-code"
        let params = MemberSendCodeRequest(phone: phone)
        
        _ = try await AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData()
        .value
    }
    
    func verifyCode(
        phone: String,
        code: String,
        password: String,
        gender: String,
    ) async throws -> MemberVerifyCodeResponse {
        let url = "http://192.168.0.14:8080/api/v1/members/phone/verify-code"
        let params = MemberVerifyCodeRequest(phone: phone, code: code, password: password, gender: gender)
        
        return try await AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .serializingDecodable(MemberVerifyCodeResponse.self)
        .value
    }
    
    func activate(
        nickname: String,
        birthYear: Int,
        bio: String,
    ) async throws {
        let url = "http://192.168.0.14:8080/api/v1/members/activate"
        let params = MemberActivateRequest(nickname: nickname, birthYear: birthYear, bio: bio)
        
        _ = try await session.request(
            url,
            method: .put,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData()
        .value
    }
    
    // MARK: 코멘트
    func writeComment(
        comment: String
    ) async throws {
        let url = "http://192.168.0.14:8080/api/v1/members/comments"
        
        let params = MemberWriteCommentRequest(
            comment: comment.isEmpty ? "반갑습니다." : comment
        )
        
        _ = try await session.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData()
        .value
    }
    
    func getComments(
        gender: String,
        cursorId: Int64?,
    ) async throws -> CursorResponse<MemberGetCommentResponse> {
        let url = "http://192.168.0.14:8080/api/v1/members/comments"
        
        var params: Parameters = [
            "gender": gender,
            "size": 15
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }
        
        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .serializingDecodable(CursorResponse<MemberGetCommentResponse>.self)
        .value
    }
    
    func bumpComment() async throws {
        let url = "http://192.168.0.14:8080/api/v1/members/comments/bump"
        
        _ = try await session.request(
            url,
            method: .put,
        )
        .validate()
        .serializingData()
        .value
    }
    
    func searchComments(
        keyword: String,
        cursorId: Int64?,
    ) async throws -> CursorResponse<MemberSearchCommentResponse> {
        let url = "http://192.168.0.14:8080/api/v1/members/comments/search"
        
        var params: Parameters = [
            "keyword": keyword,
            "size": 15
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }
        
        return try await session.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.queryString
        )
        .serializingDecodable(CursorResponse<MemberSearchCommentResponse>.self)
        .value
    }
    
    // MARK: 위치
    func getLocations(
        gender: String,
        cursorId: Int64?,
    ) async throws -> CursorResponse<MemberGetLocationResponse> {
        let url = "http://192.168.0.14:8080/api/v1/members/locations"
        
        var params: Parameters = [
            "gender": gender,
            "size": 15
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }
        
        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .serializingDecodable(CursorResponse<MemberGetLocationResponse>.self)
        .value
    }
    
    func updateLocation(
        latitude: Double?,
        longitude: Double?,
    ) async throws {
        let url = "http://192.168.0.14:8080/api/v1/members/location"
        
        let params = MemberUpdateLocationRequest(
            latitude: latitude, longitude: longitude
        )
        
        _ = try await session.request(
            url,
            method: .put,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData()
        .value
    }
}

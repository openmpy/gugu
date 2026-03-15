import SwiftUI
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    
    private let service = MemberService.shared
    
    func sendCode(phone: String) async throws {
        try await service.sendCode(phone: phone)
    }
    
    func verifyCode(phone: String, code: String, password: String, gender: String) async throws -> MemberVerifyCodeResponse {
        return try await service.verifyCode(
            phone: phone,
            code: code,
            password: password,
            gender: gender
        )
    }
    
    func activate(nickname: String, birthYear: String, bio: String) async throws {
        try await service.activate(nickname: nickname, birthYear: Int(birthYear) ?? 2000, bio: bio)
    }
}

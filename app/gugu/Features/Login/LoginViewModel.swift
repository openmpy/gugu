import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    
    private let service = MemberService.shared

    func login(phone: String, password: String) async {
        do {
            try await service.login(phone: phone, password: password)
        } catch {
            print(error)
        }
    }
}

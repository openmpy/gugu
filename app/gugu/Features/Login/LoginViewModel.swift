import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    
    private let service = MemberService.shared
    
    @Published var errorMessage: String?
    @Published var isActivated = false
    
    func login(phone: String, password: String) async {
        do {
            let response = try await service.login(phone: phone, password: password)
            
            saveToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            isActivated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveToken(accessToken: String, refreshToken: String) {
        KeychainHelper.save(key: "accessToken", value: accessToken)
        KeychainHelper.save(key: "refreshToken", value: refreshToken)
    }
}

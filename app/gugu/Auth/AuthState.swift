import SwiftUI
import Combine

class AuthState: ObservableObject {
    
    static let shared = AuthState()
    
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkLogin()
    }
    
    func checkLogin() {
        isLoggedIn = KeychainHelper.read(key: "accessToken") != nil || KeychainHelper.read(key: "refreshToken") != nil
    }
    
    func login(accessToken: String, refreshToken: String) {
        KeychainHelper.save(key: "accessToken", value: accessToken)
        KeychainHelper.save(key: "refreshToken", value: refreshToken)
        isLoggedIn = true
    }
    
    func logout() {
        KeychainHelper.delete(key: "accessToken")
        KeychainHelper.delete(key: "refreshToken")
        isLoggedIn = false
    }
}

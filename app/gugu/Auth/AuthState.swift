import SwiftUI
import Combine

class AuthState: ObservableObject {
    
    @Published var isLoggedIn: Bool = false

    init() {
        checkLogin()
    }

    func checkLogin() {
        if KeychainHelper.read(key: "refreshToken") != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}

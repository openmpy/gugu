import SwiftUI

@main
struct guguApp: App {
    
    @StateObject private var auth = AuthState.shared
    
    var body: some Scene {
        WindowGroup {
            if auth.isLoggedIn {
                ContentView()
            } else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}

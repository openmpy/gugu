import SwiftUI

@main
struct guguApp: App {
    
    @StateObject var auth = AuthState()
    
    var body: some Scene {
        WindowGroup {
            if auth.isLoggedIn {
                ContentView()
                    .environmentObject(auth)
            } else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}

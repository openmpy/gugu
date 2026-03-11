import SwiftUI

struct ChatDetailView: View {
    let id: Int
    
    var body: some View {
        VStack {
            Text("채팅방")
        }
        .navigationTitle("홍길동")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(id: 1)
    }
}

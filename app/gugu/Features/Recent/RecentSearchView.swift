import SwiftUI
import SimpleToast

struct RecentSearchView: View {
    
    @StateObject private var vm = RecentSearchViewModel()
    
    private let toastOptions = SimpleToastOptions(hideAfter: 5)
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.comments.isEmpty {
                    Text("검색 결과가 없습니다.")
                        .foregroundColor(.primary)
                } else {
                    RecentSearchMemberListView(items: $vm.comments) {
                        await vm.loadMoreSearch()
                    }
                }
            }
            .searchable(
                text: $vm.searchNickname,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임을 입력해주세요"
            )
            .onSubmit(of: .search) {
                Task {
                    await vm.search(keyword: vm.searchNickname)
                }
            }
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .simpleToast(
            isPresented: Binding(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            ),
            options: toastOptions
        ) {
            Label(vm.errorMessage ?? "", systemImage: "xmark.circle.fill")
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(12)
                .padding(.top)
        }
    }
}

#Preview {
    NavigationStack {
        RecentSearchView()
    }
}

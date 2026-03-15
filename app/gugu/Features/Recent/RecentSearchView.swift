import SwiftUI

struct RecentSearchView: View {
    
    @StateObject private var vm = RecentSearchViewModel()
    
    @State private var searchNickname: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.comments) { item in
                        RecentSearchMemberItemView(
                            item: item,
                            isLast: item.id == vm.comments.last?.id
                        ) {
                            await vm.loadMoreSearch()
                        }
                    }
                }
                .searchable(
                    text: $searchNickname,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "닉네임을 입력해주세요"
                )
                .onSubmit(of: .search) {
                    Task {
                        await vm.search(keyword: searchNickname)
                    }
                }
            }
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .alert("오류", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        RecentSearchView()
    }
}

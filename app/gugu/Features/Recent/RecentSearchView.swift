import SwiftUI

struct RecentSearchView: View {
    
    @StateObject private var vm = RecentSearchViewModel()
    
    @State private var searchNickname: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
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
                .onChange(of: searchNickname) { _, newValue in
                    Task {
                        try? await Task.sleep(for: .milliseconds(300))
                        await vm.search(keyword: newValue)
                    }
                }
            }
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .alert("알림", isPresented: $showAlert) {
            Button("닫기", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        RecentSearchView()
    }
}

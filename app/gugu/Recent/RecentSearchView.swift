import SwiftUI
import Kingfisher

struct RecentSearchView: View {
    
    @FocusState private var isSearchFieldFocused: Bool
    
    @State private var searchText: String = ""
    
    @State private var comments: [RecentSearchCommentResponse] = []
    @State private var cursorId: Int64? = nil
    @State private var hasNext: Bool = true
    @State private var isLoading: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(comments) { item in
                        NavigationLink(destination: UserDetailView(id: item.memberId)) {
                            RecentSearchCommentRow(item: item)
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                        .onAppear {
                            if item.id == comments.last?.id {
                                searchComments()
                            }
                        }
                    }
                }
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "닉네임을 입력해주세요"
                )
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) { _, _ in
                    cursorId = nil
                    hasNext = true
                    searchComments(isRefresh: true)
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
    
    func searchComments(isRefresh: Bool = false) {
        guard !isLoading, hasNext else {
            return
        }
        guard !searchText.isEmpty else {
            comments.removeAll()
            cursorId = nil
            hasNext = true
            return
        }
        
        isLoading = true
        
        RecentService.shared.searchComments(
            keyword: searchText,
            cursorId: cursorId
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let response):
                    if isRefresh {
                        comments = response.payload
                    } else {
                        comments.append(contentsOf: response.payload)
                    }
                    
                    cursorId = response.nextId
                    hasNext = response.hasNext
                    
                case .failure(let error):
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecentSearchView()
    }
}

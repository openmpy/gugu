import SwiftUI

struct RecentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all = "ALL"
        case male = "MALE"
        case female = "FEMALE"
        
        var id: Self { self }
    }
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentComment") private var savedComment: String = ""
    
    @State private var comments: [RecentGetCommentResponse] = []
    @State private var cursorId: Int64? = nil
    @State private var hasNext: Bool = true
    @State private var isLoading: Bool = false
    
    @State private var goUserSearch: Bool = false
    
    @State private var showCommentAlert: Bool = false
    @State private var comment: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Gender", selection: $selectedGender) {
                    Text("전체").tag(Gender.all)
                    Text("여자").tag(Gender.female)
                    Text("남자").tag(Gender.male)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 5)
                .onChange(of: selectedGender) { _, newGender in
                    refreshComments()
                }
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(comments) { item in
                            NavigationLink(destination: UserDetailView(id: item.memberId)) {
                                RecentCommentRow(item: item)
                            }
                            .navigationLinkIndicatorVisibility(.hidden)
                            .onAppear {
                                if item.id == comments.last?.id {
                                    loadComments()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .refreshable {
                    bumpComment()
                    refreshComments()
                }
            }
            .navigationTitle("최근")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goUserSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .navigationDestination(isPresented: $goUserSearch) {
                        UserSearchView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCommentAlert = true
                        comment = savedComment
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("코멘트", isPresented: $showCommentAlert) {
                TextField("내용을 입력해주세요", text: $comment)
                
                Button("작성", role: .confirm) {
                    writeComment()
                }
                
                Button("취소", role: .cancel) {
                }
            }
            .alert("알림", isPresented: $showAlert) {
                Button("닫기", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .onAppear {
            if comments.isEmpty {
                loadComments()
            }
        }
    }
    
    func writeComment() {
        RecentService.shared.writeComment(comment: comment) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    showAlert = true
                    savedComment = comment
                    alertMessage = "코멘트가 작성되었습니다."
                    
                case .failure(let error):
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadComments(isRefresh: Bool = false) {
        if isLoading || !hasNext {
            return
        }

        isLoading = true

        RecentService.shared.getComments(
            gender: selectedGender.rawValue,
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
    
    func refreshComments() {
        cursorId = nil
        hasNext = true
        loadComments(isRefresh: true)
    }
    
    func bumpComment() {
        RecentService.shared.bumpComment() { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    break

                case .failure(let error):
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    RecentView()
}

import SwiftUI
import Kingfisher

struct RecentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentComment") private var savedComment: String = ""
    
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
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<100) { i in
                            NavigationLink(destination: UserDetailView(id: i)) {
                                HStack(alignment: .center) {
                                    if i.isMultiple(of: 2) {
                                        KFImage(URL(string: "https://picsum.photos/\(i)")!)
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 58, height: 58)
                                            .background(Color(.systemGray3))
                                            .clipShape(Circle())
                                            .padding(.trailing, 5)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(15)
                                            .frame(width: 58, height: 58)
                                            .foregroundStyle(Color(red: 252/255, green: 231/255, blue: 243/255))
                                            .background(Color(red: 255/255, green: 120/255, blue: 160/255))
                                            .clipShape(Circle())
                                            .padding(.trailing, 5)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("닉네임 \(i)")
                                                .font(.headline)
                                                .foregroundColor(i % 2 == 0 ? Color(red: 120/255, green: 150/255, blue: 240/255) : Color(red: 255/255, green: 120/255, blue: 160/255))
                                            
                                            Spacer()
                                            
                                            Text("방금 전")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Text("안녕하세요 \(i)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        
                                        HStack {
                                            HStack {
                                                Text(i % 2 == 0 ? "남자" : "여자")
                                                Text("·")
                                                Text("29살")
                                                Text("·")
                                                Text("♥ 100")
                                            }
                                            
                                            Spacer()
                                            
                                            Text(i % 2 == 0 ? "25.2km" : "")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                            .navigationLinkIndicatorVisibility(.hidden)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
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
    }
    
    func writeComment() {
        RecentService.shared.writeComment(content: comment) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    showAlert = true
                    savedComment = comment
                    alertMessage = "코멘트가 작성되었습니다."
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
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

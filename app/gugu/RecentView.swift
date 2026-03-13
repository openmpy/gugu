import SwiftUI
import Kingfisher

struct RecentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentContent") private var savedContent: String = ""
    
    @State private var showAlert: Bool = false
    @State private var content: String = ""
    @State private var goUserSearch: Bool = false
    
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
                        showAlert = true
                        content = savedContent
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("한줄 소개", isPresented: $showAlert) {
                TextField("내용을 입력해주세요", text: $content)
                
                Button("작성", role: .confirm) {
                    savedContent = content
                }
                
                Button("취소", role: .cancel) { }
            }
        }
    }
}

#Preview {
    RecentView()
}

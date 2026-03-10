import SwiftUI

struct RecentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentContent") private var savedContent: String = ""
    
    @State private var showAlert: Bool = false
    @State private var content: String = ""
    
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
                                        AsyncImage(url: URL(string: "https://picsum.photos/60")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.blue, lineWidth: 1))
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 5)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(7)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(.pink, lineWidth: 1))
                                            .foregroundColor(.pink)
                                            .padding(.trailing, 5)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("닉네임 \(i)")
                                                .font(.headline)
                                                .foregroundColor(i % 2 == 0 ? .blue : .pink)
                                            
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
                                    
                                    Spacer()
                                }
                            }
                            .navigationLinkIndicatorVisibility(.hidden)
                            
                            Divider()
                                .padding(.vertical, 10)
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
                        print("검색 아이콘 클릭")
                    } label: {
                        Image(systemName: "magnifyingglass")
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
                
                Button("확인", role: .confirm) {
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

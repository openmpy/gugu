import SwiftUI
import Kingfisher

struct UserSearchView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
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
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "닉네임을 입력해주세요"
                )
            }
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    NavigationStack {
        UserSearchView()
    }
}

import SwiftUI

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
                                    AsyncImage(url: URL(string: "https://picsum.photos/100")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .background(Color(.systemGray5))
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.blue)
                                                .padding(7)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        @unknown default:
                                            EmptyView()
                                        }
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

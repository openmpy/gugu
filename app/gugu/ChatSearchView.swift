import SwiftUI

struct ChatSearchView: View {
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
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(.clear, lineWidth: 1))
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(.clear, lineWidth: 1))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.secondary)
                                                .padding(7)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(.secondary, lineWidth: 1))
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 5)
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(7)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.secondary, lineWidth: 1))
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 5)
                                }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("닉네임 \(i)")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("방금 전")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    HStack {
                                        Text("안녕하세요 \(i)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text("3")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(Color.red)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                Spacer()
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
            .navigationTitle("채팅 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    NavigationStack {
        ChatSearchView()
    }
}

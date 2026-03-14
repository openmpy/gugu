import SwiftUI

struct BlockListView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<100) { i in
                            NavigationLink(destination: UserDetailView(id: Int64(i))) {
                                HStack(alignment: .center) {
                                    if i.isMultiple(of: 2) {
                                        AsyncImage(url: URL(string: "https://picsum.photos/100")) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(15)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(width: 58, height: 58)
                                        .foregroundStyle(Color(.systemGray5))
                                        .background(Color(.systemGray3))
                                        .clipShape(Circle())
                                        .padding(.trailing, 5)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(15)
                                            .frame(width: 58, height: 58)
                                            .foregroundStyle(Color(.systemGray5))
                                            .background(Color(.systemGray3))
                                            .clipShape(Circle())
                                            .padding(.trailing, 5)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("닉네임 \(i)")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        HStack {
                                            Text(i % 2 == 0 ? "남자" : "여자")
                                            Text("·")
                                            Text("29살")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        showAlert = true
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(12)
                                            .frame(width: 45, height: 45)
                                            .foregroundStyle(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(.red)
                                            )
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
            .navigationTitle("차단 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .alert("차단 해제", isPresented: $showAlert) {
            Button("해제", role: .confirm) {
                print("해제하기")
            }
            
            Button("닫기", role: .cancel) { }
        } message: {
            Text("차단을 해제하시겠습니까?")
        }
    }
}

#Preview {
    BlockListView()
}

import SwiftUI

struct BlockListView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<100) { i in
                            NavigationLink(destination: UserDetailView(id: i)) {
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
                                        .foregroundStyle(Color(red: 219/255, green: 234/255, blue: 254/255))
                                        .background(Color(red: 120/255, green: 150/255, blue: 240/255))
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
                                        Text("닉네임 \(i)")
                                            .font(.headline)
                                            .foregroundColor(i % 2 == 0 ? Color(red: 120/255, green: 150/255, blue: 240/255) : Color(red: 255/255, green: 120/255, blue: 160/255))
                                        
                                        HStack {
                                            Text(i % 2 == 0 ? "남자" : "여자")
                                            Text("·")
                                            Text("29살")
                                            Text("·")
                                            Text("♥ 100")
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
                                            .padding(15)
                                            .frame(width: 58, height: 58)
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

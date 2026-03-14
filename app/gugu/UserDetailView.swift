import SwiftUI

struct UserDetailView: View {
    let id: Int64
    
    private let imageSeeds = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    @AppStorage("sentMessage") private var savedMessage: String = ""
    
    @State private var currentPage: Int = 0
    @State private var message: String = ""
    
    @State private var showSheet: Bool = false
    @State private var showMessageAlert: Bool = false
    @State private var showBlockAlert: Bool = false
    
    @State private var goReport: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center) {
                    ZStack(alignment: .bottom) {
                        TabView(selection: $currentPage) {
                            ForEach(imageSeeds.indices, id: \.self) { index in
                                let seed = imageSeeds[index]
                                
                                AsyncImage(url: URL(string: "https://picsum.photos/seed/\(seed)/1000")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color(.systemGray5))
                                    case .success(let image):
                                        NavigationLink(destination: UserImageView(image: image)) {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color(.systemGray5))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .tag(index)
                                .clipped()
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .aspectRatio(4/3, contentMode: .fit)
                        .clipped()
                        
                        HStack(spacing: 6) {
                            ForEach(imageSeeds.indices, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage
                                          ? Color.white
                                          : Color.white.opacity(0.5))
                                    .frame(
                                        width: index == currentPage ? 8 : 6,
                                        height: index == currentPage ? 8 : 6
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                            }
                        }
                        .padding(.bottom, 12)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(currentPage + 1) / \(imageSeeds.count)")
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.black.opacity(0.45))
                                    .clipShape(Capsule())
                                    .padding(12)
                            }
                            Spacer()
                        }
                    }
                    .aspectRatio(4/3, contentMode: .fit)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("홍길동")
                                .font(.largeTitle.bold())
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("방금 전")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            HStack {
                                Text(id % 2 == 0 ? "남자" : "여자")
                                Text("·")
                                Text("29살")
                                Text("·")
                                Text("♥ 100")
                            }
                            
                            Spacer()
                            
                            Text(id % 2 == 0 ? "25.2km" : "")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Text("안녕하세요")
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.vertical)
                    }
                    .padding()
                }
                .padding(.bottom, 60)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        print("좋아요 클릭")
                    } label: {
                        Image(systemName: "heart.fill")
                            .frame(width: 60, height: 60)
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                            .glassEffect()
                    }
                    
                    Spacer()
                    
                    Button {
                        showMessageAlert = true
                        message = savedMessage
                    } label: {
                        Image(systemName: "message.fill")
                            .frame(width: 60, height: 60)
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .glassEffect()
                    }
                    
                    Spacer()
                    
                    Button {
                        print("비밀사진 클릭")
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "photo")
                                .frame(width: 60, height: 60)
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                                .glassEffect()
                            
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Text("10")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                )
                                .offset(x: 0, y: 2)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        showBlockAlert = true
                    } label: {
                        Image(systemName: "nosign")
                            .frame(width: 60, height: 60)
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                            .glassEffect()
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                }
                .confirmationDialog("", isPresented: $showSheet) {
                    Button("비밀 사진 열기") { print("비밀 사진 열기") }
                    Button("신고하기", role: .destructive) { goReport = true }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .navigationDestination(isPresented: $goReport) {
            UserReportView()
        }
        .alert("쪽지", isPresented: $showMessageAlert) {
            TextField("내용을 입력해주세요", text: $message)
            
            Button("전송", role: .confirm) {
                savedMessage = message
                print(savedMessage)
            }
            
            Button("취소", role: .cancel) { }
        }
        .alert("차단", isPresented: $showBlockAlert) {
            Button("차단", role: .destructive) {
                print("차단하기")
            }
            
            Button("취소", role: .cancel) { }
        } message: {
            Text("차단하면 채팅 내역이 모두 삭제됩니다.")
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(id: 2)
    }
}

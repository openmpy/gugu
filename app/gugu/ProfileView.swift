import SwiftUI

struct ProfileView: View {
    private let imageSeeds = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    @State private var currentPage: Int = 0
    
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
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        Text("홍길동")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text("남자")
                            Text("·")
                            Text("29살")
                            Text("·")
                            Text("♥ 100")
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
            .ignoresSafeArea(.keyboard)
        }
        .navigationTitle("프로필")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ProfileEditorView()
                } label: {
                    Text("편집")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

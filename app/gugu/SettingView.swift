import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showSheet: Bool = false
    
    struct SettingItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
        let type: ItemType
        
        enum ItemType {
            case view(AnyView)
            case link(String)
        }
    }
    
    var items: [SettingItem] {
        [
            .init(title: "내 프로필", icon: "person.crop.circle.fill", color: .blue, type: .view(AnyView(ProfileView()))),
            .init(title: "하트 목록", icon: "heart.fill", color: .red, type: .view(AnyView(HeartListView()))),
            .init(title: "비밀 사진 목록", icon: "photo.fill", color: .green, type: .view(AnyView(SecretPhotoListView()))),
            .init(title: "차단 목록", icon: "nosign", color: .red, type: .view(AnyView(BlockListView()))),
            
                .init(title: "포인트", icon: "star.circle.fill", color: .yellow, type: .view(AnyView(PointView()))),
            .init(title: "출석 체크", icon: "calendar.circle.fill", color: .orange, type: .view(AnyView(EmptyView()))),
            .init(title: "광고 보상", icon: "gift.fill", color: .pink, type: .view(AnyView(EmptyView()))),
            
                .init(title: "공지사항", icon: "megaphone.fill", color: .teal, type: .link("https://example.com/notice")),
            .init(title: "문의사항", icon: "envelope.fill", color: .indigo, type: .link(makeMailURL())),
            .init(title: "서비스 이용약관", icon: "doc.text.fill", color: .gray, type: .link("https://example.com/terms")),
            .init(title: "개인정보 취급방침", icon: "shield.fill", color: .green, type: .link("https://example.com/privacy"))
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    SectionView(items: [items[0]])
                    SectionView(items: Array(items[1...3]))
                    SectionView(items: Array(items[4...6]))
                    SectionView(items: Array(items[7...10]))
                }
                .padding(.vertical)
            }
            .background(
                colorScheme == .light
                ? Color(uiColor: .systemGray6)
                : Color(uiColor: .systemBackground)
            )
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .confirmationDialog("설정", isPresented: $showSheet) {
                        Button("탈퇴하기", role: .destructive) {}
                    }
                }
            }
        }
    }
    
    func makeMailURL() -> String {
        let userID = "12345"
        let device = deviceIdentifier()
        let iosVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let body = """
        
        
        --------------------
        ID: \(userID)
        기기: \(device)
        iOS 버전: \(iosVersion)
        앱 버전: \(appVersion)
        --------------------
        """
        
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "gugu.kor.cs@gmail.com"
        components.queryItems = [
            URLQueryItem(name: "subject", value: "문의하기"),
            URLQueryItem(name: "body", value: body)
        ]
        
        return components.url?.absoluteString ?? ""
    }
    
    func deviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }
}

struct SectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    
    let items: [SettingView.SettingItem]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Group {
                    switch item.type {
                        
                    case .view(let destination):
                        NavigationLink(destination: destination) {
                            row(item)
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                        
                    case .link(let url):
                        Button {
                            if let url = URL(string: url) {
                                openURL(url)
                            }
                        } label: {
                            row(item)
                        }
                    }
                }
                .background(
                    colorScheme == .light
                    ? Color(.systemBackground)
                    : Color(.systemGray6)
                )
                
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    func row(_ item: SettingView.SettingItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: item.icon)
                .font(.system(size: 25))
                .foregroundColor(item.color)
                .frame(width: 35, height: 35)
            
            Text(item.title)
                .foregroundColor(.primary)
                .font(.system(size: 18, weight: .medium))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

#Preview {
    SettingView()
}

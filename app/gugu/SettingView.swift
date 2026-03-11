import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showSheet: Bool = false
    
    struct SettingItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
    }
    
    let items: [SettingItem] = [
        .init(title: "내 프로필", icon: "person.crop.circle.fill", color: .blue),
        .init(title: "하트 목록", icon: "heart.fill", color: .red),
        .init(title: "비밀 사진 목록", icon: "photo.fill", color: .green),
        .init(title: "차단 목록", icon: "nosign", color: .red),
        .init(title: "포인트", icon: "star.circle.fill", color: .yellow),
        .init(title: "출석 체크", icon: "calendar.circle.fill", color: .orange),
        .init(title: "광고 보상", icon: "gift.fill", color: .pink),
        .init(title: "공지사항", icon: "megaphone.fill", color: .teal),
        .init(title: "문의사항", icon: "envelope.fill", color: .indigo),
        .init(title: "서비스 이용약관", icon: "doc.text.fill", color: .gray),
        .init(title: "개인정보 취급방침", icon: "shield.fill", color: .green)
    ]
    
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
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(
                            title: Text(""),
                            buttons: [
                                .destructive(Text("탈퇴하기")) {},
                                .cancel()
                            ]
                        )
                    }
                }
            }
        }
    }
}

struct SectionView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let items: [SettingView.SettingItem]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
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
                .background(colorScheme == .light ? Color(.systemBackground): Color(.systemGray6))
                
                // 항목 사이 구분선
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    SettingView()
}

import SwiftUI

struct MemberItemView: View {
    
    let item: MemberDisplayable
    let isLast: Bool
    let gender: String
    let loadMore: () async -> Void
    
    var body: some View {
        NavigationLink(destination: UserDetailView(id: item.memberId)) {
            MemberRowView(
                nickname: item.nickname,
                gender: item.gender,
                age: item.age,
                heartCount: item.heartCount,
                distance: item.distance,
                content: item.content,
                updatedAt: item.updatedAt
            )
        }
        .navigationLinkIndicatorVisibility(.hidden)
        .onAppear {
            if isLast {
                Task {
                    await loadMore()
                }
            }
        }
    }
}

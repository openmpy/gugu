import SwiftUI

struct RecentMemberItemView: View {
    
    let item: MemberGetCommentResponse
    let isLast: Bool
    let gender: String
    let loadMore: () async -> Void
    
    var body: some View {
        NavigationLink(destination: UserDetailView(id: item.memberId)) {
            RecentMemberRow(item: item)
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

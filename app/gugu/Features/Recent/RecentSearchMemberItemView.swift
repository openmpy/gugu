import SwiftUI

struct RecentSearchMemberItemView: View {
    
    let item: MemberSearchCommentResponse
    let isLast: Bool
    let loadMore: () async -> Void
    
    var body: some View {
        NavigationLink(destination: UserDetailView(id: item.memberId)) {
            RecentSearchMemberRow(item: item)
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

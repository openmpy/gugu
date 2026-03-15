import SwiftUI

struct RecentSearchMemberListView: View {
    
    @Binding var items: [MemberSearchCommentResponse]
    let loadMore: () async -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(items) { item in
                    RecentSearchMemberItemView(
                        item: item,
                        isLast: item.memberId == items.last?.memberId,
                        loadMore: loadMore
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

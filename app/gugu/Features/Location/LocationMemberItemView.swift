import SwiftUI

struct LocationMemberItemView: View {
    
    let item: MemberGetLocationResponse
    let isLast: Bool
    let gender: String
    let loadMore: () async -> Void
    
    var body: some View {
        NavigationLink(destination: UserDetailView(id: item.memberId)) {
            LocationMemberRow(item: item)
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

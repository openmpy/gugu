import SwiftUI

struct MemberListView<Item: MemberDisplayable>: View {
    
    @Binding var items: [Item]
    let selectedGender: String
    let loadMore: () async -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.memberId) { item in
                    MemberItemView(
                        item: item,
                        isLast: item.memberId == items.last?.memberId,
                        gender: selectedGender
                    ) {
                        Task {
                            await loadMore()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

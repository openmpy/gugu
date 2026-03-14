import SwiftUI
import Kingfisher

struct RecentSearchCommentRow: View {
    let item: RecentSearchCommentResponse
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://picsum.photos/100"))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFill()
                .frame(width: 58, height: 58)
                .clipShape(Circle())
                .padding(.trailing, 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(item.nickname)
                        .font(.headline)
                        .foregroundColor(
                            item.gender == "MALE"
                            ? Color(red: 120/255, green: 150/255, blue: 240/255)
                            : Color(red: 255/255, green: 120/255, blue: 160/255)
                        )
                    
                    Spacer()
                    
                    Text(DateHelper.timeAgoString(from: item.updatedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(item.comment)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(item.gender == "MALE" ? "남자" : "여자")
                    Text("·")
                    Text("\(item.age)살")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

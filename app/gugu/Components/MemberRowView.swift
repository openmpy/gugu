import SwiftUI
import Kingfisher

struct MemberRowView: View {
    
    let nickname: String
    let gender: String
    let age: Int
    let heartCount: Int
    let distance: Double?
    let content: String?
    let updatedAt: String
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://picsum.photos/100"))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 58, height: 58)
                .clipShape(Circle())
                .padding(.trailing, 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(nickname)
                        .font(.headline)
                        .foregroundColor(
                            gender == "MALE"
                            ? Color(red: 120/255, green: 150/255, blue: 240/255)
                            : Color(red: 255/255, green: 120/255, blue: 160/255)
                        )
                    
                    Spacer()
                    
                    Text(DateHelper.timeAgoString(from: updatedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(content ?? "작성하지 않은 상태입니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(gender == "MALE" ? "남자" : "여자")
                    Text("·")
                    Text("\(age)살")
                    Text("·")
                    Text("♥ \(heartCount)")
                    
                    Spacer()
                    
                    if let distance = distance {
                        Text(String(format: "%.1fkm", distance))
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

import SwiftUI
import Kingfisher

struct ChatView: View {
    enum Status: String, CaseIterable, Identifiable {
        case all, read, unread
        var id: Self { self }
    }
    
    @AppStorage("selectedChatStatus") private var selectedStatus: Status = .all
    @State private var goChatUserSearch: Bool = false
    @State private var chats = Array(0..<100)
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Status", selection: $selectedStatus) {
                    Text("전체").tag(Status.all)
                    Text("읽음").tag(Status.read)
                    Text("안읽음").tag(Status.unread)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 5)
                
                List {
                    ForEach(chats, id: \.self) { i in
                        NavigationLink(destination: ChatDetailView(id: i)) {
                            chatRow(i: i)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .navigationLinkIndicatorVisibility(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                withAnimation {
                                }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(role: .confirm) {
                                withAnimation {
                                }
                            } label: {
                                Label("읽음", systemImage: "eye")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goChatUserSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .navigationDestination(isPresented: $goChatUserSearch) {
                        ChatSearchView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func chatRow(i: Int) -> some View {
        HStack(alignment: .center) {
            if i.isMultiple(of: 2) {
                KFImage(URL(string: "https://picsum.photos/\(i)")!)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 58, height: 58)
                    .background(Color(.systemGray3))
                    .clipShape(Circle())
                    .padding(.trailing, 5)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(15)
                    .frame(width: 58, height: 58)
                    .foregroundColor(Color(.systemGray5))
                    .background(Color(.systemGray3))
                    .clipShape(Circle())
                    .padding(.trailing, 5)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("닉네임 \(i)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("방금 전")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(alignment: .top) {
                    Text("안녕하세요 \(i)")
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("3")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    ChatView()
}

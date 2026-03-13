import SwiftUI
import Kingfisher

extension String {
    var byCharWrapping: Self {
        map(String.init).joined(separator: "\u{200B}")
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct BottomPositionKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
    let isMe: Bool
}

struct MessageBubble: View {
    let text: String
    let isMe: Bool
    
    var body: some View {
        Text(text.byCharWrapping)
            .padding(10)
            .background(isMe ? Color.blue : Color(.systemGray5))
            .foregroundColor(isMe ? .white : .primary)
            .cornerRadius(12)
            .contextMenu {
                Button {
                    UIPasteboard.general.string = text
                } label: {
                    Label("복사", systemImage: "doc.on.doc")
                }
            }
    }
}

struct MessageTimeView: View {
    let date: Date
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Text(formattedTime)
            .font(.caption2)
            .foregroundColor(.gray)
    }
}

struct ChatDetailView: View {
    let id: Int
    
    @State private var message: String = ""
    @State private var isAtBottom: Bool = true
    @State private var scrollViewHeight: CGFloat = 0
    @State private var textViewHeight: CGFloat = 40
    
    @StateObject private var keyboard = KeyboardResponder()
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "안녕하세요! 안녕하세요! 안녕하세요! 안녕하세요!", date: Date().addingTimeInterval(-3600), isMe: false),
        ChatMessage(text: "안녕하세요, 반가워요! 안녕하세요, 반가워요! 안녕하세요, 반가워요! 안녕하세요, 반가워요!", date: Date().addingTimeInterval(-3500), isMe: true),
        ChatMessage(text: "오늘 날씨 좋네요.", date: Date().addingTimeInterval(-1800), isMe: false),
        ChatMessage(text: "그러게요! 산책 가야겠어요.", date: Date().addingTimeInterval(-1200), isMe: true),
        ChatMessage(text: "좋아요~", date: Date().addingTimeInterval(-600), isMe: false)
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(messages) { msg in
                                HStack {
                                    if msg.isMe { Spacer() }
                                    
                                    HStack(alignment: .bottom, spacing: 4) {
                                        if msg.isMe {
                                            MessageTimeView(date: msg.date)
                                            MessageBubble(text: msg.text, isMe: true)
                                        } else {
                                            MessageBubble(text: msg.text, isMe: false)
                                            MessageTimeView(date: msg.date)
                                        }
                                    }
                                    
                                    if !msg.isMe { Spacer() }
                                }
                                .id(msg.id)
                            }
                            
                            Color.clear
                                .frame(height: 1)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: BottomPositionKey.self,
                                            value: geo.frame(in: .named("scroll")).maxY
                                        )
                                    }
                                )
                                .id("bottom")
                        }
                        .padding(.horizontal)
                        .onChange(of: messages.count) { _, _ in
                            if let last = messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                scrollViewHeight = geo.size.height
                            }
                            .onChange(of: geo.size.height) { _, newHeight in
                                scrollViewHeight = newHeight
                            }
                        }
                    )
                    .onPreferenceChange(BottomPositionKey.self) { bottomY in
                        isAtBottom = bottomY <= scrollViewHeight + 10
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .onChange(of: keyboard.currentHeight) { _, _ in
                        if isAtBottom, let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                HStack(alignment: .bottom) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .padding(10)
                            .foregroundColor(Color(.systemGray2))
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    HStack(alignment: .bottom) {
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("메시지 입력")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.vertical, 10)
                                    .padding(.leading, 15)
                            }
                            
                            ChatTextView(
                                text: $message,
                                minHeight: 20,
                                maxHeight: 120,
                                height: $textViewHeight
                            )
                            .frame(height: textViewHeight)
                            .padding(.vertical, 10)
                            .padding(.leading, 15)
                        }
                        
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 20))
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 5)
                        .padding(.bottom, 3.5)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.top, 5)
            }
        }
        .navigationTitle("홍길동")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    UserDetailView(id: 1)
                } label: {
                    KFImage(URL(string: "https://picsum.photos/\(id)")!)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 27, height: 27)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    func sendMessage() {
        guard !message.isEmpty else { return }
        let newMessage = ChatMessage(text: message, date: Date(), isMe: true)
        messages.append(newMessage)
        message = ""
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(id: 1)
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            Tab("최근", systemImage: "clock") {
                RecentView()
            }
            
            Tab("거리", systemImage: "location") {
                LocationView()
            }
            
            Tab("채팅", systemImage: "bubble") {
                ChatView()
            }
            
            Tab("설정", systemImage: "gear") {
                SettingView()
            }
        }
    }
}

struct ChatView: View {
    enum Status: String, CaseIterable, Identifiable {
        case all, read, unread
        var id: Self { self }
    }
    
    @AppStorage("selectedChatStatus") private var selectedStatus: Status = .all
    
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
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<100) { i in
                            Text("Row \(i)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        print("검색 아이콘 클릭")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("쪽지 토글 아이콘 클릭")
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

struct SettingView: View {
    var body: some View {
        Text("설정 화면")
    }
}

#Preview {
    ContentView()
}

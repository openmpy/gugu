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

struct RecentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentContent") private var savedContent: String = ""
    
    @State private var showAlert: Bool = false
    @State private var content: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Gender", selection: $selectedGender) {
                    Text("전체").tag(Gender.all)
                    Text("여자").tag(Gender.female)
                    Text("남자").tag(Gender.male)
                }
                .pickerStyle(.segmented)
                .padding()
                
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
            .navigationTitle("최근")
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
                        showAlert = true
                        content = savedContent
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("한줄 작성", isPresented: $showAlert) {
                TextField("내용을 입력해주세요", text: $content)
                
                Button("확인", role: .confirm) {
                    savedContent = content
                }
                
                Button("취소", role: .cancel) {
                }
            }
        }
    }
}

struct LocationView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedLocationGender") private var selectedGender: Gender = .all
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Gender", selection: $selectedGender) {
                    Text("전체").tag(Gender.all)
                    Text("여자").tag(Gender.female)
                    Text("남자").tag(Gender.male)
                }
                .pickerStyle(.segmented)
                .padding()
                
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
            .navigationTitle("거리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        print("검색 아이콘 클릭")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
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
                .padding()
                
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

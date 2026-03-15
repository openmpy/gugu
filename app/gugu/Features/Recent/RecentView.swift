import SwiftUI
import CoreLocation

struct RecentView: View {
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    @AppStorage("recentComment") private var savedComment: String = ""
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = RecentViewModel()
    @StateObject private var lvm = LocationViewModel()
    
    @State private var showCommentAlert: Bool = false
    @State private var comment: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var goUserSearch: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Gender", selection: $selectedGender) {
                    ForEach(Gender.allCases) { gender in
                        Text(gender.text)
                            .tag(gender)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 5)
                .onChange(of: selectedGender) { _, newGender in
                    Task {
                        await vm.fetchComments(gender: newGender.rawValue)
                    }
                }
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.comments) { item in
                            RecentMemberItemView(
                                item: item,
                                isLast: item.id == vm.comments.last?.id,
                                gender: selectedGender.rawValue
                            ) {
                                await vm.loadMore(gender: selectedGender.rawValue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .refreshable {
                    Task {
                        _ = await (vm.bumpComment(), vm.fetchComments(gender: selectedGender.rawValue))
                    }
                }
            }
            .navigationTitle("최근")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goUserSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .navigationDestination(isPresented: $goUserSearch) {
                        RecentSearchView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCommentAlert = true
                        comment = savedComment
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("코멘트", isPresented: $showCommentAlert) {
                TextField("내용을 입력해주세요", text: $comment)
                
                Button("작성") {
                    Task {
                        await vm.writeComment(comment: comment)
                        
                        savedComment = comment
                        alertMessage = "코멘트가 작성되었습니다."
                        showAlert = true
                    }
                }
                Button("취소", role: .cancel) { }
            }
            .alert("알림", isPresented: $showAlert) {
                Button("닫기", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .task {
            if vm.comments.isEmpty {
                await vm.fetchComments(gender: selectedGender.rawValue)
            }
        }
        .onChange(of: locationManager.currentLocation) { _, newLocation in
            guard let loc = newLocation else {
                Task {
                    await lvm.updateLocation(
                        latitude: nil,
                        longitude: nil
                    )
                }
                return
            }
            
            Task {
                await lvm.updateLocation(
                    latitude: loc.coordinate.latitude,
                    longitude: loc.coordinate.longitude
                )
            }
        }
    }
}

#Preview {
    RecentView()
}

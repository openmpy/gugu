import SwiftUI
import CoreLocation
import SimpleToast

struct RecentView: View {
    
    @AppStorage("selectedRecentGender") private var selectedGender: Gender = .all
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = RecentViewModel()
    
    @State private var showCommentAlert: Bool = false
    @State private var comment: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var goUserSearch: Bool = false
    
    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )
    
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
                .simpleToast(isPresented: $vm.showToast, options: toastOptions) {
                    Label(vm.toastMessage ?? "", systemImage: "info.circle.fill")
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                        .padding(.top)
                }
                .simpleToast(
                    isPresented: Binding(
                        get: { vm.errorMessage != nil },
                        set: { if !$0 { vm.errorMessage = nil } }
                    ),
                    options: toastOptions
                ) {
                    Label(vm.errorMessage ?? "", systemImage: "xmark.circle.fill")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                        .padding(.top)
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
                        comment = vm.savedComment
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .task {
            if vm.comments.isEmpty {
                await vm.fetchComments(gender: selectedGender.rawValue)
            }
        }
        .onChange(of: locationManager.currentLocation) { _, newLocation in
            Task {
                await vm.updateLocation(
                    latitude: newLocation?.coordinate.latitude,
                    longitude: newLocation?.coordinate.longitude
                )
            }
        }
        .alert("코멘트", isPresented: $showCommentAlert) {
            TextField("내용을 입력해주세요", text: $comment)
            
            Button("작성") {
                Task {
                    await vm.writeComment(comment: comment)
                }
            }
            Button("취소", role: .cancel) { }
        }
    }
}

#Preview {
    RecentView()
}

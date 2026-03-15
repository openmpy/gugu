import SwiftUI
import CoreLocation
import SimpleToast

struct RecentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = RecentViewModel()
    
    @State private var goUserSearch: Bool = false
    
    private let toastOptions = SimpleToastOptions(hideAfter: 5)
    
    var body: some View {
        NavigationStack {
            VStack {
                GenderPickerView(selectedGender: $vm.selectedGender) { _, newGender in
                    Task {
                        await vm.fetchComments(gender: newGender.rawValue)
                    }
                }
                
                MemberListView(
                    items: $vm.comments,
                    selectedGender: vm.selectedGender.rawValue
                ) {
                    await vm.loadMore(gender: vm.selectedGender.rawValue)
                }
                .refreshable {
                    Task {
                        _ = await (vm.bumpComment(), vm.fetchComments(gender: vm.selectedGender.rawValue))
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
                        vm.showCommentAlert = true
                        vm.comment = vm.savedComment
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .task {
            if vm.comments.isEmpty {
                await vm.fetchComments(gender: vm.selectedGender.rawValue)
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
        .alert("코멘트", isPresented: $vm.showCommentAlert) {
            TextField("내용을 입력해주세요", text: $vm.comment)
            
            Button("작성") {
                Task {
                    await vm.writeComment(comment: vm.comment)
                }
            }
            Button("취소", role: .cancel) { }
        }
    }
}

#Preview {
    RecentView()
}

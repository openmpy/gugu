import SwiftUI
import CoreLocation
import SimpleToast

struct LocationView: View {
    
    @AppStorage("selectedLocationGender") private var selectedGender: Gender = .all
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = LocationViewModel()
    
    private let toastOptions = SimpleToastOptions(hideAfter: 5)
    
    var body: some View {
        NavigationStack {
            if locationManager.isLocationEnabled {
                VStack {
                    GenderPickerView(selectedGender: $vm.selectedGender) { _, newGender in
                        Task {
                            await vm.fetchLocations(gender: newGender.rawValue)
                        }
                    }
                    
                    MemberListView(
                        items: $vm.locations,
                        selectedGender: vm.selectedGender.rawValue
                    ) {
                        await vm.loadMore(gender: vm.selectedGender.rawValue)
                    }
                    .refreshable {
                        Task {
                            await vm.fetchLocations(gender: selectedGender.rawValue)
                        }
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
                .navigationTitle("거리")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    if vm.locations.isEmpty {
                        await vm.fetchLocations(gender: selectedGender.rawValue)
                    }
                }
                .onChange(of: locationManager.currentLocation) { _, newLocation in
                    guard let loc = newLocation else {
                        Task {
                            await vm.updateLocation(
                                latitude: nil,
                                longitude: nil
                            )
                        }
                        return
                    }
                    
                    Task {
                        await vm.updateLocation(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude
                        )
                    }
                }
            } else {
                LocationPermissionView {
                    openSettings()
                }
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    LocationView()
}

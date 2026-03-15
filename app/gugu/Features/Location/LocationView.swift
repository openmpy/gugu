import SwiftUI
import CoreLocation

struct LocationView: View {
    
    @AppStorage("selectedLocationGender") private var selectedGender: Gender = .all
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = LocationViewModel()
    
    var body: some View {
        NavigationStack {
            if locationManager.isLocationEnabled {
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
                            await vm.fetchLocations(gender: newGender.rawValue)
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(vm.locations) { item in
                                LocationMemberItemView(
                                    item: item,
                                    isLast: item.id == vm.locations.last?.id,
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
                            await vm.fetchLocations(gender: selectedGender.rawValue)
                        }
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
                VStack(spacing: 20) {
                    Text("위치 접근 허용이 꺼져 있습니다.")
                        .font(.headline)
                    
                    Text("설정에서 위치 접근을 허용해주세요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button {
                        openSettings()
                    } label: {
                        Text("설정으로 이동")
                            .font(.headline)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .alert("오류", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
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

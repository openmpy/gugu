import SwiftUI
import CoreLocation

struct LocationView: View {
    
    enum Gender: String, CaseIterable, Identifiable {
        case all = "ALL"
        case male = "MALE"
        case female = "FEMALE"
        
        var id: Self { self }
    }
    
    @AppStorage("selectedLocationGender") private var selectedGender: Gender = .all
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var locations: [LocationGetMemberResponse] = []
    @State private var cursorId: Int64? = nil
    @State private var hasNext: Bool = true
    @State private var isLoading: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            if locationManager.isLocationEnabled {
                VStack {
                    Picker("Gender", selection: $selectedGender) {
                        Text("전체").tag(Gender.all)
                        Text("여자").tag(Gender.female)
                        Text("남자").tag(Gender.male)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 5)
                    .onChange(of: selectedGender) { _, newGender in
                        refreshLocations()
                    }
                    
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(locations) { item in
                                NavigationLink(destination: UserDetailView(id: item.memberId)) {
                                    LocationMemberRow(item: item)
                                }
                                .navigationLinkIndicatorVisibility(.hidden)
                                .onAppear {
                                    if item.id == locations.last?.id {
                                        loadLocations()
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .refreshable {
                        refreshLocations()
                    }
                }
                .navigationTitle("거리")
                .navigationBarTitleDisplayMode(.inline)
                .alert("알림", isPresented: $showAlert) {
                    Button("닫기", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                .onAppear {
                    if locations.isEmpty {
                        loadLocations()
                    }
                }
                .onChange(of: locationManager.currentLocation) { _, newLocation in
                    if let loc = newLocation {
                        LocationService.shared.updateLocation(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude
                        ) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    break
                                case .failure(let error):
                                    showAlert = true
                                    alertMessage = error.localizedDescription
                                }
                            }
                        }
                    } else {
                        LocationService.shared.updateLocation(latitude: nil, longitude: nil) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    break
                                case .failure(let error):
                                    showAlert = true
                                    alertMessage = error.localizedDescription
                                }
                            }
                        }
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
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func loadLocations(isRefresh: Bool = false) {
        if isLoading || !hasNext {
            return
        }
        
        isLoading = true
        
        LocationService.shared.getLocations(
            gender: selectedGender.rawValue,
            cursorId: cursorId
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let response):
                    if isRefresh {
                        locations = response.payload
                    } else {
                        locations.append(contentsOf: response.payload)
                    }
                    
                    cursorId = response.nextId
                    hasNext = response.hasNext
                    
                case .failure(let error):
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refreshLocations() {
        cursorId = nil
        hasNext = true
        loadLocations(isRefresh: true)
    }
}

#Preview {
    LocationView()
}

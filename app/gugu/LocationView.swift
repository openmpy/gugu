import SwiftUI
import CoreLocation

struct LocationView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case all, male, female
        var id: Self { self }
    }
    
    @AppStorage("selectedLocationGender") private var selectedGender: Gender = .all
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var goUserSearch: Bool = false
    
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
                    
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(0..<100) { i in
                                NavigationLink(destination: UserDetailView(id: Int64(i))) {
                                    HStack(alignment: .center) {
                                        if i.isMultiple(of: 2) {
                                            AsyncImage(url: URL(string: "https://picsum.photos/100")) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(15)
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 58, height: 58)
                                            .foregroundStyle(Color(red: 219/255, green: 234/255, blue: 254/255))
                                            .background(Color(red: 120/255, green: 150/255, blue: 240/255))
                                            .clipShape(Circle())
                                            .padding(.trailing, 5)
                                        } else {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(15)
                                                .frame(width: 58, height: 58)
                                                .foregroundStyle(Color(red: 252/255, green: 231/255, blue: 243/255))
                                                .background(Color(red: 255/255, green: 120/255, blue: 160/255))
                                                .clipShape(Circle())
                                                .padding(.trailing, 5)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("닉네임 \(i)")
                                                    .font(.headline)
                                                    .foregroundColor(i % 2 == 0 ? Color(red: 120/255, green: 150/255, blue: 240/255) : Color(red: 255/255, green: 120/255, blue: 160/255))
                                                
                                                Spacer()
                                                
                                                Text("방금 전")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Text("안녕하세요 \(i)")
                                                .font(.subheadline)
                                                .lineLimit(1)
                                                .foregroundColor(.secondary)
                                            
                                            HStack {
                                                HStack {
                                                    Text(i % 2 == 0 ? "남자" : "여자")
                                                    Text("·")
                                                    Text("29살")
                                                    Text("·")
                                                    Text("♥ 100")
                                                }
                                                
                                                Spacer()
                                                
                                                Text(i % 2 == 0 ? "25.2km" : "")
                                            }
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                }
                                .navigationLinkIndicatorVisibility(.hidden)
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
                            goUserSearch = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .navigationDestination(isPresented: $goUserSearch) {
                            UserSearchView()
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
}

#Preview {
    LocationView()
}

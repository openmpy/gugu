import SwiftUI
import PhotosUI
import SwiftUIReorderableForEach

struct SignupActivateView: View {
    
    @EnvironmentObject var auth: AuthState
    
    @StateObject private var vm = SignupViewModel()
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var profileImages: [UIImage] = []
    
    @State private var nickname: String = ""
    @State private var birthYear: String = ""
    @State private var bio: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var allowReordering: Bool = true
    @State private var goLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        imageSection(
                            title: "프로필 사진 (최대 10장)",
                            images: $profileImages,
                            pickerItems: $selectedItems,
                            showBadge: true
                        )
                        
                        VStack(alignment: .leading) {
                            Text("닉네임")
                                .font(.headline)
                            
                            TextField("닉네임을 입력해주세요.", text: $nickname)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading) {
                            Text("출생연도")
                                .font(.headline)
                            
                            TextField("출생연도를 입력해주세요.", text: $birthYear)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                                .keyboardType(.numberPad)
                                .onChange(of: birthYear) { _, newValue in
                                    if newValue.count > 4 {
                                        birthYear = String(newValue.prefix(4))
                                    }
                                }
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading) {
                            Text("자기소개")
                                .font(.headline)
                            
                            TextEditor(text: $bio)
                                .frame(height: 120)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    Task {
                        do {
                            try await vm.activate(nickname: nickname, birthYear: birthYear, bio: bio)
                            
                            auth.isLoggedIn = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("회원가입")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(nickname.isEmpty || birthYear.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(nickname.isEmpty || birthYear.isEmpty)
                .padding()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .onTapGesture {
                KeyboardHelper.hideKeyboard()
            }
            .onChange(of: selectedItems) { _, newItems in
                loadImages(
                    items: newItems,
                    target: $profileImages,
                    pickerItems: $selectedItems
                )
            }
        }
        .alert("알림", isPresented: $showAlert) {
            Button("닫기", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func imageSection(
        title: String,
        images: Binding<[UIImage]>,
        pickerItems: Binding<[PhotosPickerItem]>,
        showBadge: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ReorderableForEach(images, allowReordering: $allowReordering) { image, isDragging in
                        let index = images.wrappedValue.firstIndex(of: image) ?? 0
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(12)
                            .opacity(isDragging ? 0.7 : 1.0)
                            .overlay(
                                Button {
                                    images.wrappedValue.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, .red)
                                }
                                    .padding(5),
                                alignment: .topTrailing
                            )
                            .overlay(
                                AnyView(
                                    showBadge && index == 0 ?
                                    Text("대표")
                                        .font(.caption2)
                                        .bold()
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                        .padding(5)
                                    : nil
                                ),
                                alignment: .topLeading
                            )
                    }
                    
                    if images.wrappedValue.count < 10 {
                        PhotosPicker(
                            selection: pickerItems,
                            maxSelectionCount: 10 - images.wrappedValue.count,
                            matching: .images
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color(.systemGray4),
                                        style: StrokeStyle(lineWidth: 1, dash: [5])
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(Color(.systemGray4))
                            }
                        }
                    }
                }
            }
            
            Text("이미지를 드래그하여 순서를 변경할 수 있습니다.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
    }
    
    func loadImages(
        items: [PhotosPickerItem],
        target: Binding<[UIImage]>,
        pickerItems: Binding<[PhotosPickerItem]>
    ) {
        Task {
            for item in items {
                if target.wrappedValue.count >= 10 { break }
                
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    target.wrappedValue.append(image)
                }
            }
            pickerItems.wrappedValue.removeAll()
        }
    }
}

#Preview {
    SignupActivateView()
}

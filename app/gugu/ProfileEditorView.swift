import SwiftUI
import PhotosUI

struct ProfileEditorView: View {
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var secretSelectedItems: [PhotosPickerItem] = []
    
    @State private var profileImages: [UIImage] = []
    @State private var secretImages: [UIImage] = []
    
    @State private var nickname: String = ""
    @State private var birthYear: String = ""
    @State private var bio: String = ""
    
    var body: some View {
        ScrollView {
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
                
                imageSection(
                    title: "비밀 사진 (최대 10장)",
                    images: $secretImages,
                    pickerItems: $secretSelectedItems,
                    showBadge: false
                )
                
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
                .padding(.bottom)
                
                Spacer()
                
                Button {
                    print("수정하기")
                } label: {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(nickname.isEmpty || birthYear.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(nickname.isEmpty || birthYear.isEmpty)
            }
            .navigationTitle("프로필 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: selectedItems) { _, newItems in
            loadImages(
                items: newItems,
                target: $profileImages,
                pickerItems: $selectedItems
            )
        }
        .onChange(of: secretSelectedItems) { _, newItems in
            loadImages(
                items: newItems,
                target: $secretImages,
                pickerItems: $secretSelectedItems
            )
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
                    ForEach(images.wrappedValue.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: images.wrappedValue[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(12)
                            
                            if showBadge && index == 0 {
                                VStack {
                                    HStack {
                                        Text("대표")
                                            .font(.caption2)
                                            .bold()
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(5)
                            }
                            
                            Button {
                                images.wrappedValue.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, .red)
                            }
                            .offset(x: -5, y: 5)
                        }
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
                .padding(.bottom)
            }
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
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    NavigationStack {
        ProfileEditorView()
    }
}

import SwiftUI
import PhotosUI
import SwiftUIReorderableForEach

struct TestView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var allowReordering = true
    
    var body: some View {
        VStack {
            // 사진 선택 버튼
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 10,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("사진 선택")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .onChange(of: selectedItems) { _, newItems in
                Task {
                    var tempImages: [UIImage] = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            tempImages.append(uiImage)
                        }
                    }
                    images = tempImages
                }
            }
            .padding(.bottom)
            
            Text("드래그해서 순서 변경")
                .font(.headline)
            
            // 드래그 가능 이미지 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ReorderableForEach($images, allowReordering: $allowReordering) { image, isDragging in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .shadow(radius: isDragging ? 8 : 0)
                            .opacity(isDragging ? 0.7 : 1.0)
                    }
                }
                .padding()
            }
            
            Button("순서 초기화") {
                images.removeAll()
                selectedItems.removeAll()
            }
            .padding(.top)
        }
        .animation(.default, value: images)
        .padding()
    }
}

#Preview {
    TestView()
}

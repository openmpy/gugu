import SwiftUI
import PhotosUI
import SwiftUIReorderableForEach

struct UserReportView: View {
    enum ReportReason: String, CaseIterable, Identifiable {
        case abuse = "욕설 / 비방"
        case spam = "스팸 / 광고"
        case minor = "미성년자"
        case sexual = "음란물"
        case fake = "도용"
        case etc = "기타"
        var id: Self { self }
    }
    
    @State private var selectedReason: ReportReason?
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var allowReordering = true
    @State private var images: [UIImage] = []
    @State private var detailText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("신고 사유")
                    .font(.headline)
                
                VStack(spacing: 12) {
                    ForEach(ReportReason.allCases) { reason in
                        Button {
                            selectedReason = reason
                        } label: {
                            HStack {
                                Text(reason.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedReason == reason {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("증거 자료 (최대 5장)")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ReorderableForEach($images, allowReordering: $allowReordering) { image, isDragging in
                                let index = images.firstIndex(of: image) ?? 0
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(12)
                                    .opacity(isDragging ? 0.7 : 1.0)
                                    .overlay(
                                        Button {
                                            images.remove(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.white, .red)
                                        }
                                            .padding(5),
                                        alignment: .topTrailing
                                    )
                            }
                            
                            if images.count < 5 {
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 5 - images.count,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, dash: [5]))
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
                
                VStack(alignment: .leading) {
                    Text("추가 설명 (선택)")
                        .font(.headline)
                    
                    TextEditor(text: $detailText)
                        .frame(height: 120)
                        .padding(8)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
                .padding(.bottom)
                
                Spacer()
                
                Button {
                    print("신고")
                } label: {
                    Text("신고하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedReason == nil ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(selectedReason == nil)
                
            }
            .navigationTitle("신고 (홍길동)")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: selectedItems) { _, newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        
                        if images.count < 5 {
                            images.append(image)
                        }
                    }
                }
                selectedItems.removeAll()
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationStack {
        UserReportView()
    }
}

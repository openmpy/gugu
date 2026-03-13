import SwiftUI

struct ChatTextView: UIViewRepresentable {
    @Binding var text: String
    var minHeight: CGFloat = 40
    var maxHeight: CGFloat = 120
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        ChatTextView.recalculateHeight(view: uiView, result: $height, min: minHeight, max: maxHeight)
    }
    
    static func recalculateHeight(view: UITextView, result: Binding<CGFloat>, min: CGFloat, max: CGFloat) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .infinity))
        let newHeight = Swift.min(Swift.max(newSize.height, min), max)
        if result.wrappedValue != newHeight {
            DispatchQueue.main.async {
                result.wrappedValue = newHeight
                view.isScrollEnabled = newSize.height > max
            }
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ChatTextView
        
        init(_ parent: ChatTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            ChatTextView.recalculateHeight(
                view: textView,
                result: parent.$height,
                min: parent.minHeight,
                max: parent.maxHeight
            )
        }
    }
}

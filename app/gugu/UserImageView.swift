import SwiftUI
import Zoomable

struct UserImageView: View {
    let image: Image
    
    var body: some View {
        NavigationStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .zoomable()
        }
        .background(.black)
    }
}

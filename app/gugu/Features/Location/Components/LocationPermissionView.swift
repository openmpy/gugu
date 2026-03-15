import SwiftUI

struct LocationPermissionView: View {
    var onOpenSettings: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("위치 접근 허용이 꺼져 있습니다.")
                .font(.headline)
            
            Text("설정에서 위치 접근을 허용해주세요.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                onOpenSettings()
            } label: {
                Text("설정으로 이동")
                    .font(.headline)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .glassEffect(.regular.tint(.blue))
            }
        }
        .padding()
    }
}

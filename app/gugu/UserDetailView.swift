//
//  UserDetailView.swift
//  gugu
//
//  Created by suhwan on 3/10/26.
//

import SwiftUI

struct UserDetailView: View {
    let id: Int
    
    var body: some View {
        Text("회원 상세 화면 \(id)")
            .font(.largeTitle)
    }
}

#Preview {
    UserDetailView(id: 1)
}

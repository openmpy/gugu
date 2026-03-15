struct MemberGetCommentResponse: Decodable, Identifiable {
    
    let memberId: Int64
    let nickname: String
    let gender: String
    let age: Int
    let heartCount: Int
    let distance: Double?
    let comment: String
    let updatedAt: String
    
    var id: Int64 { memberId }
}

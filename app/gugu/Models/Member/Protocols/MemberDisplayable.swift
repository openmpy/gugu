import Foundation

protocol MemberDisplayable {
    var memberId: Int64 { get }
    var nickname: String { get }
    var gender: String { get }
    var age: Int { get }
    var heartCount: Int { get }
    var distance: Double? { get }
    var content: String? { get }
    var updatedAt: String { get }
}

extension MemberGetCommentResponse: MemberDisplayable {
    var content: String? { comment }
}

extension MemberGetLocationResponse: MemberDisplayable {
    var content: String? { bio }
}

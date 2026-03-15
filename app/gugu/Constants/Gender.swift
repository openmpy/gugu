import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case all = "ALL"
    case male = "MALE"
    case female = "FEMALE"
    
    var id: Self { self }
    
    var text: String {
        switch self {
        case .all: return "전체"
        case .male: return "남자"
        case .female: return "여자"
        }
    }
}

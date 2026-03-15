import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case all = "ALL"
    case female = "FEMALE"
    case male = "MALE"
    
    var id: Self { self }
    
    var text: String {
        switch self {
        case .all: return "전체"
        case .female: return "여자"
        case .male: return "남자"
        }
    }
}

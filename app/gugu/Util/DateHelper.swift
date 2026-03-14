import UIKit

struct DateHelper {

    static func timeAgoString(from isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"

        guard let date = formatter.date(from: isoString) else {
            return isoString
        }

        let seconds = Int(Date().timeIntervalSince(date))

        if seconds < 60 {
            return "방금 전"
        } else if seconds < 3600 {
            return "\(seconds / 60)분 전"
        } else if seconds < 86400 {
            return "\(seconds / 3600)시간 전"
        } else {
            return "\(seconds / 86400)일 전"
        }
    }
}

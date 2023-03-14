import Foundation

extension Date {
    func dateToVisibleString() -> String {
        return stringDateWithFormat(format: "dd.MM.yyyy")
    }
    
    func stringDateWithFormat(format: String, locale: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let locale = locale {
            formatter.locale = Locale(identifier: locale)
        }
        return formatter.string(from: self)
    }
    
    
}


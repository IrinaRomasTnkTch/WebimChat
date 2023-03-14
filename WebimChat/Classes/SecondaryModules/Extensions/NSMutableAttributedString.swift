import UIKit

// MARK: Set Color
extension NSMutableAttributedString {
    func setColor(_ color: AppColor) -> NSMutableAttributedString {
        let range = self.mutableString.range(of: self.string)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color.getColor(), range: range)
        return self
    }
    
    func setColor(_ color: UIColor) -> NSMutableAttributedString {
        let range = self.mutableString.range(of: self.string)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return self
    }
}

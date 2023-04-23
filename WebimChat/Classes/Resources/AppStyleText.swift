import UIKit

// MARK: AppStyleFontName
enum AppStyleFontName: String, CaseIterable {
    case ptRootBolt = "PTRootUI-Bold"
    case ptRootMedium = "PTRootUI-Medium"
    
    func getFileName() -> String {
        switch self {
        case .ptRootBolt: return "PT Root UI_Bold"
        case .ptRootMedium: return "PT Root UI_Medium"
        }
    }
}

// MARK: AppStyleText
enum AppStyleText {
    // Display, Title
    case title3
    
    // Body
    case bodyBold
    case bodyMedium
    
    // Caption
    case caption
    case captionSmall
    
    func getAttributedStringKeys() -> [NSAttributedString.Key : Any] {
        switch self {

        case .title3:           return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 20)
        
        case .bodyBold:         return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 16)
        case .bodyMedium:       return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 16)
        
        case .caption:          return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 14)
        case .captionSmall:     return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 12)
        }
    }
    
    func getFontName() -> String {
        switch self {

        case .title3:           return AppStyleFontName.ptRootBolt.rawValue
        
        case .bodyBold:         return AppStyleFontName.ptRootBolt.rawValue
        case .bodyMedium:       return AppStyleFontName.ptRootMedium.rawValue
      
        case .caption:          return AppStyleFontName.ptRootMedium.rawValue
        case .captionSmall:     return AppStyleFontName.ptRootMedium.rawValue
        }
    }
    
    func getFont() -> UIFont {
        let attributedStringKeys = getAttributedStringKeys()
        return (attributedStringKeys[NSAttributedString.Key.font] as? UIFont) ?? UIFont()
    }
    
    func getKern() -> Double {
        let attributedStringKeys = getAttributedStringKeys()
        return attributedStringKeys[NSAttributedString.Key.kern] as! Double
    }
    
    private func createAttributes(kern: Double, nameFont: AppStyleFontName, sizeFont: CGFloat, lineHeight: CGFloat? = nil) -> [NSAttributedString.Key : Any] {
        if let lineHeight = lineHeight {
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.lineHeightMultiple = lineHeight
          return [NSAttributedString.Key.kern: kern, NSAttributedString.Key.font: UIFont(name: nameFont.rawValue, size: sizeFont)!].merging([NSAttributedString.Key.paragraphStyle : paragraphStyle], uniquingKeysWith: { (_, last) in last })
        } else {
            return [NSAttributedString.Key.kern: kern, NSAttributedString.Key.font: UIFont(name: nameFont.rawValue, size: sizeFont) ?? UIFont.systemFont(ofSize: sizeFont)]
        }
      }
}


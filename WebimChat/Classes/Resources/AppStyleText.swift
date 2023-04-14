import UIKit

// MARK: AppStyleFontName
enum AppStyleFontName: String {
    case ptRootBolt = "PTRootUI-Bold"
    case ptRootMedium = "PTRootUI-Medium"
}

// MARK: AppStyleText
enum AppStyleText {
    // Display, Title
//    case title1
//    case title2
    case title3
    
    // Body Big
//    case bodyBigBold
//    case bodyBigMedium
    
    // Body
    case bodyBold
    case bodyMedium
//    case bodyMediumTight
    
    // Caption
    case caption
//    case captionBolt
    case captionSmall
//    case captionSmallBold
    
    func getAttributedStringKeys() -> [NSAttributedString.Key : Any] {
        switch self {

//        case .title1:           return createAttributes(kern: -0.14, nameFont: .ptRootBolt, sizeFont: 36)
//        case .title2:           return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 24)
        case .title3:           return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 20)
        
//        case .bodyBigBold:      return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 18, lineHeight: 0.8)
//        case .bodyBigMedium:    return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 18)
        
        case .bodyBold:         return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 16)
        case .bodyMedium:       return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 16)
//        case .bodyMediumTight:  return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 16, lineHeight: 0.8)
        
        case .caption:          return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 14)
//        case .captionBolt:      return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 14)
        case .captionSmall:     return createAttributes(kern: -0.01, nameFont: .ptRootMedium, sizeFont: 12)
//        case .captionSmallBold: return createAttributes(kern: -0.01, nameFont: .ptRootBolt, sizeFont: 12)
        }
    }
    
    func getFontName() -> String {
        switch self {

//        case .title1:           return AppStyleFontName.ptRootBolt.rawValue
//        case .title2:           return AppStyleFontName.ptRootBolt.rawValue
        case .title3:           return AppStyleFontName.ptRootBolt.rawValue
//        
//        case .bodyBigBold:      return AppStyleFontName.ptRootBolt.rawValue
//        case .bodyBigMedium:    return AppStyleFontName.ptRootMedium.rawValue
//        
        case .bodyBold:         return AppStyleFontName.ptRootBolt.rawValue
        case .bodyMedium:       return AppStyleFontName.ptRootMedium.rawValue
//        case .bodyMediumTight:  return AppStyleFontName.ptRootMedium.rawValue
//        
        case .caption:          return AppStyleFontName.ptRootMedium.rawValue
//        case .captionBolt:      return AppStyleFontName.ptRootBolt.rawValue
        case .captionSmall:     return AppStyleFontName.ptRootMedium.rawValue
//        case .captionSmallBold: return AppStyleFontName.ptRootBolt.rawValue
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
          return [NSAttributedString.Key.kern: kern, NSAttributedString.Key.font: UIFont(name: nameFont.rawValue, size: sizeFont)]
        }
      }
}


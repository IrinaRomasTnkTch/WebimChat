import UIKit

// MARK: App Color
enum AppColor {
    // Primary Brand
    case primary1 //red
    case primary2 //black
    case primary3 //white
    
    // Primary 1 palette
//    case accent700
//    case accent600
//    case accent500
//    case accent400
//    case accent300
//    case accent100
    case accent200
    
    // Primary 2 palette
//    case grey20
//    case grey30
    case grey40
    case grey50
    case grey60
//    case grey100
//    case grey200
//    case grey250
    case grey300
//    case grey400
//    case grey500
//    case grey600
//    case grey650
//    case grey700
//    case grey800
//    case grey900
//    case grey950
    
    // On Surface Primary 1
//    case onSurfaceP1High
//    case onSurfaceP1Medium
//    case onSurfaceP1Low
    
    // On Surface Primary 2
    case onSurfaceP2High
    case onSurfaceP2Medium
//    case onSurfaceP2Low
    
    // On Surface Primary 3
    case onSurfaceP3High
//    case onSurfaceP3Medium
//    case onSurfaceP3Low
    
    // Color Alert
//    case alertError
//    case alertPositive
//    case alertAttention
    
    // Surface overlay
//    case surfaceOverlayScrim
//    case overlayP2

//    case yellow01
//    case brown01
//    case orange
    
    case feedBackStarActive
    
    // Clear
    case clear
    
    func getColor() -> UIColor {
        return AppColorPreset.getColor(style: self)
    }
}

// MARK: App Color Preset
final class AppColorPreset {
    fileprivate init() {}

    static func getColor(style: AppColor) -> UIColor {
        let mode = AppStyle.shared.getAppStyleMode()
        switch mode {
        case .whiteDefault: return getWhiteDefaultColor(style: style)
        case .black: return .black //getBlackColor(typeObject: AppStyleColorPreset)
        }
    }
    
    static private func getWhiteDefaultColor(style: AppColor) -> UIColor {
        switch style {
        case .primary1:                 return UIColor(displayP3Red: 0.98,      green: 0.18,    blue: 0.07,     alpha: 1.00)
        case .primary2:                 return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 1.00)
        case .primary3:                 return UIColor(displayP3Red: 1.00,      green: 1.00,    blue: 1.00,     alpha: 1.00)
////        case .accent700:                return UIColor(displayP3Red: 0.38,      green: 0.07,    blue: 0.03,     alpha: 1.00)
////        case .accent600:                return UIColor(displayP3Red: 0.59,      green: 0.11,    blue: 0.04,     alpha: 1.00)
////        case .accent500:                return UIColor(displayP3Red: 0.79,      green: 0.15,    blue: 0.06,     alpha: 1.00)
//        case .accent400:                return UIColor(displayP3Red: 0.99,      green: 0.43,    blue: 0.35,     alpha: 1.00)
////        case .accent300:                return UIColor(displayP3Red: 0.99,      green: 0.59,    blue: 0.54,     alpha: 1.00)
//        case .accent100:                return UIColor(displayP3Red: 1.00,      green: 0.92,    blue: 0.91,     alpha: 1.00)
        case .accent200:                return UIColor(displayP3Red: 0.996,      green: 0.753,    blue: 0.722,     alpha: 1.00)
//        case .grey20:                   return UIColor(displayP3Red: 0.98,      green: 0.98,    blue: 0.98,     alpha: 1.00)
//        case .grey30:                   return UIColor(displayP3Red: 0.965,     green: 0.965,   blue: 0.965,    alpha: 1.00)
        case .grey40:                   return UIColor(displayP3Red: 0.96,      green: 0.95,    blue: 0.95,     alpha: 1.00)
        case .grey50:                   return UIColor(displayP3Red: 0.94,      green: 0.92,    blue: 0.92,     alpha: 1.00)
        case .grey60:                   return UIColor(displayP3Red: 0.938,     green: 0.938,   blue: 0.938,    alpha: 1.00)
//        case .grey100:                  return UIColor(displayP3Red: 0.90,      green: 0.88,    blue: 0.88,     alpha: 1.00)
//        case .grey200:                  return UIColor(displayP3Red: 0.80,      green: 0.77,    blue: 0.77,     alpha: 1.00)
//        case .grey250:                  return UIColor(displayP3Red: 0.769,     green: 0.769,   blue: 0.769,    alpha: 1.00)
        case .grey300:                  return UIColor(displayP3Red: 0.70,      green: 0.67,    blue: 0.66,     alpha: 1.00)
//        case .grey400:                  return UIColor(displayP3Red: 0.60,      green: 0.57,    blue: 0.56,     alpha: 1.00)
//        case .grey500:                  return UIColor(displayP3Red: 0.48,      green: 0.46,    blue: 0.46,     alpha: 1.00)
////        case .grey600:                  return UIColor(displayP3Red: 0.38,      green: 0.37,    blue: 0.36,     alpha: 1.00)
//        case .grey650:                  return UIColor(displayP3Red: 0.312,     green: 0.312,   blue: 0.312,    alpha: 1.00)
//        case .grey700:                  return UIColor(displayP3Red: 0.28,      green: 0.27,    blue: 0.27,     alpha: 1.00)
//        case .grey800:                  return UIColor(displayP3Red: 0.18,      green: 0.17,    blue: 0.17,     alpha: 1.00)
////        case .grey900:                  return UIColor(displayP3Red: 0.10,      green: 0.10,    blue: 0.10,     alpha: 1.00)
////        case .grey950:                  return UIColor(displayP3Red: 0.04,      green: 0.04,    blue: 0.04,     alpha: 1.00)
//        case .onSurfaceP1High:          return UIColor(displayP3Red: 0.98,      green: 0.18,    blue: 0.07,     alpha: 0.88)
////        case .onSurfaceP1Medium:        return UIColor(displayP3Red: 0.98,      green: 0.18,    blue: 0.07,     alpha: 0.72)
//        case .onSurfaceP1Low:           return UIColor(displayP3Red: 0.98,      green: 0.18,    blue: 0.07,     alpha: 0.40)
        case .onSurfaceP2High:          return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 0.88)
        case .onSurfaceP2Medium:        return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 0.64)
//        case .onSurfaceP2Low:           return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 0.40)
        case .onSurfaceP3High:          return UIColor(displayP3Red: 1.00,      green: 1.00,    blue: 1.00,     alpha: 1.00)
//        case .onSurfaceP3Medium:        return UIColor(displayP3Red: 1.00,      green: 1.00,    blue: 1.00,     alpha: 0.72)
//        case .onSurfaceP3Low:           return UIColor(displayP3Red: 1.00,      green: 1.00,    blue: 1.00,     alpha: 0.40)
//        case .alertError:               return UIColor(displayP3Red: 0.79,      green: 0.15,    blue: 0.06,     alpha: 1.00)
//        case .alertPositive:            return UIColor(displayP3Red: 0.24,      green: 0.64,    blue: 0.21,     alpha: 1.00)
//        case .alertAttention:           return UIColor(displayP3Red: 0.992,     green: 0.914,   blue: 0.063,    alpha: 1.00)
////        case .surfaceOverlayScrim:      return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 0.50)
//        case .overlayP2:                return UIColor(displayP3Red: 0.00,      green: 0.00,    blue: 0.00,     alpha: 0.08)
//        case .yellow01:                 return UIColor(displayP3Red: 1.00,      green: 0.93,    blue: 0.58,     alpha: 1.00)
//        case .brown01:                  return UIColor(displayP3Red: 0.70,      green: 0.45,    blue: 0.00,     alpha: 1.00)
//        case .orange:                   return UIColor(displayP3Red: 1.00,      green: 0.60,    blue: 0.20,     alpha: 0.88)
        case .feedBackStarActive:       return UIColor(displayP3Red: 1.00,      green: 0.823,   blue: 0.196,    alpha: 1)
        case .clear:                    return UIColor.clear
        }
    }
}

import UIKit

enum AppStyleMode {
    case whiteDefault
    case black
}

// MARK: AppStyle
final class AppStyle {
    static let shared = AppStyle()
    
    private(set) var systemDarkModeEnabled = false
    private(set) var customStyleSelected = false
    private var appStyleMode = AppStyleMode.whiteDefault
    
    private init() {}
    
    public func darkMode(enabled: Bool) {
        systemDarkModeEnabled = enabled
        changeUserStyle()
    }
    
    public func customStyle(selected: Bool) {
        customStyleSelected = selected
        changeUserStyle()
    }
    
    public func customStyle(select: AppStyleMode) {
        if customStyleSelected {
            appStyleMode = select
        }
        changeUserStyle()
    }
    
    public func getAppStyleMode() -> AppStyleMode {
//###     return customStyleSelected ? appStyleMode : (systemDarkModeEnabled ? .black : .whiteDefault)
        return .whiteDefault
    }
    
    private func changeUserStyle() {
        if !customStyleSelected {
            appStyleMode = systemDarkModeEnabled ? .black : .whiteDefault
        }
    }
}






    


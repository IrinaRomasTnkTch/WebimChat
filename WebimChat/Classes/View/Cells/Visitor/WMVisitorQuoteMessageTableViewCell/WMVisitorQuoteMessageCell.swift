import UIKit

class WMVisitorQuoteMessageCell: WMQuoteMessageCell {
     
    override func initialSetup() -> Bool {
        messageView.backgroundColor = AppColor.primary3.getColor()
        let setup = super.initialSetup()
        if setup {
            self.sharpCorner(view: messageView, visitor: true)
        }
        return setup
    }
}

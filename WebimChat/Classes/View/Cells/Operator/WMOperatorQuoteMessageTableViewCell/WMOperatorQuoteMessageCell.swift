import UIKit

class WMOperatorQuoteMessageCell: WMQuoteMessageCell {
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        messageView.backgroundColor = AppColor.primary3.getColor()
        messageTextView.backgroundColor = AppColor.primary3.getColor()
        quoteView?.backgroundColor = AppColor.primary3.getColor()
        if setup {
            self.sharpCorner(view: messageView, visitor: false)
        }
        return setup
    }
}

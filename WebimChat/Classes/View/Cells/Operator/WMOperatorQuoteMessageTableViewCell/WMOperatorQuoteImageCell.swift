import UIKit
import WebimClientLibraryUpdated

class WMOperatorQuoteImageCell: WMQuoteImageCell {
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
    }
    
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

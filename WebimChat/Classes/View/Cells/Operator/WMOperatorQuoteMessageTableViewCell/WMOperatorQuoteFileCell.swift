import UIKit
import WebimClientLibraryUpdated

class WMOperatorQuoteFileCell: WMQuoteFileCell {
    
    @IBOutlet var quoteLine: UIView!
  
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        
        self.fileStatus.isUserInteractionEnabled = true // ??
        self.fileStatus.isHidden = false
    }

    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        quoteLine.backgroundColor = AppColor.primary1.getColor()
        messageView.backgroundColor = AppColor.primary3.getColor()
        messageTextView.backgroundColor = AppColor.primary3.getColor()
        quoteView?.backgroundColor = AppColor.primary3.getColor()
        if setup {
            self.sharpCorner(view: messageView, visitor: false)
        }
        return setup
    }
}

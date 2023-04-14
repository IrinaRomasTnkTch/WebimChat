import UIKit
import WebimClientLibraryUpdated

class WMVisitorQuoteFileCell: WMQuoteFileCell {
    
    @IBOutlet var quoteLine: UIView?
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        
        self.fileStatus.isUserInteractionEnabled = true
        self.fileStatus.isHidden = false
    }
    
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        messageView.backgroundColor = AppColor.accent200.getColor()
        quoteLine?.backgroundColor = AppColor.primary1.getColor()
        if setup {
            self.sharpCorner(view: messageView, visitor: true)
        }
        return setup
    }
}

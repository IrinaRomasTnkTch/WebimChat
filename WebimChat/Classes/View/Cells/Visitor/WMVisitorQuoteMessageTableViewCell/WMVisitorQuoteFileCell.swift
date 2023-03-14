import UIKit
import WebimClientLibraryUpdated

class WMVisitorQuoteFileCell: WMQuoteFileCell {
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        
        self.fileStatus.isUserInteractionEnabled = true
        self.fileStatus.isHidden = false
    }
    
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        if setup {
            self.sharpCorner(view: messageView, visitor: true)
        }
        return setup
    }
}

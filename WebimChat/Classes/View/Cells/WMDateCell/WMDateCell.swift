import UIKit
import WebimClientLibraryUpdated

class WMDateCell: WMMessageTableCell {
    @IBOutlet var borderView: UIView!
    @IBOutlet var messageTextView: UILabel!
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        self.messageTextView.attributedText = message.getTime().dateToVisibleString().styleBase(.caption, color: .primary3)
    }
    override func initialSetup() -> Bool {
        borderView.backgroundColor = AppColor.primary2.getColor()
        borderView.layer.cornerRadius = 44
        let setup = super.initialSetup()
        return setup
    }
}

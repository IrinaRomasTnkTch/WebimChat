import UIKit
import WebimClientLibraryUpdated

class WMInfoCell: WMMessageTableCell {
    @IBOutlet var borderView: UIView!
    @IBOutlet var messageTextView: UILabel!
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        self.messageTextView.attributedText = message.getText().styleBase(.caption, color: UIColor(red: 0.6, green: 0.568, blue: 0.564, alpha: 1))
    }
    override func initialSetup() -> Bool {
        borderView.backgroundColor = AppColor.grey50.getColor()
        borderView.layer.cornerRadius = 8
        let setup = super.initialSetup()
        return setup
    }
}

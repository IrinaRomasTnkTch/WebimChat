import UIKit
import WebimClientLibraryUpdated

class WMQuoteMessageCell: WMMessageTableCell {
    
    @IBOutlet var quoteMessageText: UILabel!
    @IBOutlet var quoteAuthorName: UILabel!
    @IBOutlet var quoteLine: UIView?
    
    @IBOutlet var messageTextView: UITextView!
    
    override func initialSetup() -> Bool {
        quoteLine?.backgroundColor = AppColor.primary1.getColor()
        messageView.backgroundColor = AppColor.accent200.getColor()
        return super.initialSetup()
    }
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)
        
        self.quoteMessageText.attributedText = message.getQuote()?.getMessageText()?.styleBase(.bodyMedium, color: .primary2)
        self.quoteAuthorName.attributedText = message.getQuote()?.getSenderName()?.styleBase(.bodyBold, color: .primary2)
        let checkLink = self.messageTextView.setTextWithReferences(message.getText(), alignment: .left)
        self.messageTextView.isUserInteractionEnabled = true
        for recognizer in messageTextView.gestureRecognizers ?? [] {
            if recognizer.isKind(of: UITapGestureRecognizer.self) && !checkLink {
                recognizer.delegate = self
            }
            if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                recognizer.isEnabled = false
            }
        }
    }
        
}

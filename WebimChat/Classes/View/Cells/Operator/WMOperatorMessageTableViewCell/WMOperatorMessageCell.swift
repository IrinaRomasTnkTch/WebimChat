import Foundation
import UIKit
import Nuke
import WebimClientLibraryUpdated

class WMOperatorMessageCell: WMMessageTableCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var messageTextView: UITextView!
    
    override func setMessage(message: Message, tableView: UITableView) {
        super.setMessage(message: message, tableView: tableView)

        let checkLink = self.messageTextView.setTextWithReferences(
            message.getText(),
            textColor: AppColor.primary2.getColor(),
            alignment: .left)
        messageTextView.removeInsets()
        messageTextView.delegate = self

        if !cellMessageWasInited {
            cellMessageWasInited = true
            for recognizer in messageTextView.gestureRecognizers ?? [] {
                if recognizer.isKind(of: UITapGestureRecognizer.self) && !checkLink {
                    recognizer.delegate = self
                }
                if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                    recognizer.isEnabled = false
                }
            }
            let longPressPopupGestureRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(longPressAction)
            )
            longPressPopupGestureRecognizer.minimumPressDuration = 0.2
            longPressPopupGestureRecognizer.cancelsTouchesInView = false
            self.messageTextView.addGestureRecognizer(longPressPopupGestureRecognizer)
        }
        
        if let url = message.getSenderAvatarFullURL() {
            
            let defaultRequestOptions = ImageRequestOptions()
            let imageRequest = ImageRequest(
                url: url,
                processors: [ImageProcessor.Circle()],
                priority: .normal,
                options: defaultRequestOptions
            )
            
            let loadingOptions = ImageLoadingOptions(
                placeholder: UIImage.chatImageWith(named: "Avatar"),
                transition: .fadeIn(duration: 0.5)
            )
            
            Nuke.loadImage(
                with: imageRequest,
                options: loadingOptions,
                into: avatarImageView
            )
        }
    }

    override func resignTextViewFirstResponder() {
        messageTextView.resignFirstResponder()
    }
    
    override func initialSetup() -> Bool {
        messageView.backgroundColor = AppColor.primary3.getColor()
        avatarImageView.backgroundColor = .clear
        avatarImageView.image = UIImage.chatImageWith(named: "Avatar")
        
        let setup = super.initialSetup()
        if setup {
            self.sharpCorner(view: messageView, visitor: false)
        }
        return setup
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.selectedTextRange?.isEmpty == false else { return }
        delegate?.cellChangeTextViewSelection(self)
    }
}

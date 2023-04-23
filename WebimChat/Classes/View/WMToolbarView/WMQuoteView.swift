import UIKit
import Nuke
import WebimClientLibraryUpdated

enum WMQuoteViewMode {
    case quote
    case edit
}

protocol WMQuoteViewDelegate: AnyObject {
    func cleanTextView()
}

class WMQuoteView: UIView, URLSessionDelegate {
    @IBOutlet var quoteView: UIView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet var quoteMessageText: UILabel!
    @IBOutlet var quoteAuthorName: UILabel!
    @IBOutlet var quoteImageView: UIImageView!
    @IBOutlet var quoteLine: UIView!
    @IBOutlet var fileDownloadIndicator: CircleProgressIndicator!
    @IBOutlet var downloadStatusLabel: UILabel!
    @IBOutlet weak var quoteCloseButton: UIButton!
    @IBOutlet weak var deviderLine: UIView!
    
    weak var delegate: WMDialogCellDelegate?
    var fileSize: Int64 = 0
    var fileURL: URL?
    
    private var mode = WMQuoteViewMode.quote
    
    func currentMessage() -> String {
        return quoteMessageText.text ?? ""
    }

    func currentMode() -> WMQuoteViewMode {
        return mode
    }
    
    func addQuoteEditBarForMessage(_ message: Message, delegate: WMDialogCellDelegate) {
        mode = WMQuoteViewMode.edit
        self.delegate = delegate
        self.setupTextQuoteMessage(quoteText: message.getText(), quoteAuthor: String.unwarpOrEmpty(message.getSenderName()), fromOperator: message.isOperatorType())
    }
    
    func addQuoteBarForMessage(_ message: Message, delegate: WMDialogCellDelegate) {
        self.delegate = delegate
        mode = WMQuoteViewMode.quote
        if message.isText() {
            self.setupTextQuoteMessage(quoteText: message.getText(), quoteAuthor: message.getSenderName(), fromOperator: message.isOperatorType())
        } else if message.isFile() {
            guard let fileInfo = message.getData()?.getAttachment()?.getFileInfo(), let quoteState = message.getData()?.getAttachment()?.getState() else {
                return
            }
            if let imageURL = fileInfo.getImageInfo()?.getThumbURL() {
                self.setupImageQuoteMessage(quoteAuthor: message.getSenderName(), url: imageURL, fileInfo: fileInfo, fromOperator: message.isOperatorType())
            } else if let fileURL = fileInfo.getURL() {
                self.setupFileQuoteMessage(quoteText: fileInfo.getFileName(), quoteAuthor: message.getSenderName(), url: fileURL, fileInfo: fileInfo, quoteState: quoteState, openFileDelegate: delegate, fromOperator: message.isOperatorType())
            }
        }
    }
    
    func setup(_ quoteText: String, _ quoteAuthor: String, _ fromOperator: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        quoteView.backgroundColor = AppColor.primary3.getColor()
        replyImageView.backgroundColor = .clear
        replyImageView.image = UIImage.chatImageWith(named: "fluent_arrow-reply-16-filled")
        quoteAuthorName.attributedText = quoteAuthor.styleBase(.bodyBold, color: .primary2)
        quoteView.layer.cornerRadius = 10
        quoteMessageText.attributedText = quoteText.styleBase(.bodyMedium, color: .primary2)
        quoteView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        quoteLine.backgroundColor = AppColor.primary1.getColor()
        
        let closeBtnImage = UIImage.chatImageWith(named: "close-24px")?.withRenderingMode(.alwaysTemplate)
        quoteCloseButton.setImage(closeBtnImage, for: .normal)
        quoteCloseButton.imageView?.tintColor = UIColor(red: 0.6, green: 0.568, blue: 0.564, alpha: 1)
        quoteCloseButton.addTarget(self, action: #selector(removeQuoteEditBar), for: .touchUpInside)
        
        deviderLine.backgroundColor = AppColor.grey50.getColor()
    }
    
    func setupTextQuoteMessage(quoteText: String, quoteAuthor: String, fromOperator: Bool) {
        self.setup(quoteText, quoteAuthor, fromOperator)
        self.quoteMessageText.text = quoteText
        self.quoteAuthorName.text = quoteAuthor
        self.quoteImageView.isHidden = true
        self.quoteImageView.removeConstraints(quoteImageView.constraints)
        self.quoteMessageText.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 12.0).isActive = true
        self.quoteAuthorName.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 12.0).isActive = true
    }
    
    func setupImageQuoteMessage(quoteAuthor: String, url: URL, fileInfo: FileInfo, fromOperator: Bool) {
        self.setup("Image".localized, quoteAuthor, fromOperator)
        self.quoteImageView.isHidden = false
        updateQuoteImageViewConstraints()
        self.quoteImageView.accessibilityIdentifier = url.absoluteString
        let request = ImageRequest(url: url)
        if let imageContainer = ImageCache.shared[request] {
            self.quoteImageView.image = imageContainer
        } else {
            WMFileDownloadManager.shared.subscribeForImage(url: url, progressListener: self)
        }
    }
    
    func setupFileQuoteMessage(quoteText: String, quoteAuthor: String, url: URL, fileInfo: FileInfo, quoteState: AttachmentState, openFileDelegate: WMDialogCellDelegate, fromOperator: Bool) {
        self.setup(quoteText, quoteAuthor, fromOperator)
        self.quoteImageView.isHidden = false
        updateQuoteImageViewConstraints()
        self.fileURL = url
        self.fileSize = fileInfo.getSize() ?? 0
        self.quoteImageView.image = UIImage.chatImageWith(named: "FileDownloadButton")
    }
    
    override func loadXibViewSetup() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        layer.addSublayer(topBorder)
    }
    
    @objc private func removeQuoteEditBar() {
        if mode == .edit {
            self.delegate?.cleanTextView()
        }
        self.removeFromSuperview()
    }

    private func updateQuoteImageViewConstraints() {
        quoteMessageText.leftAnchor.constraint(equalTo: self.quoteImageView.rightAnchor, constant: 10.0).isActive = true
        quoteAuthorName.leftAnchor.constraint(equalTo: self.quoteImageView.rightAnchor, constant: 10.0).isActive = true
        quoteImageView.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 8.0).isActive = true
        quoteImageView.heightAnchor.constraint(equalTo: self.quoteImageView.widthAnchor).isActive = true
    }
}

extension WMQuoteView: WMFileDownloadProgressListener {
    func progressChanged(url: URL, progress: Float, image: UIImage?) {
        quoteImageView.image = image ?? UIImage.chatImageWith(named: "placeholder")
    }
}

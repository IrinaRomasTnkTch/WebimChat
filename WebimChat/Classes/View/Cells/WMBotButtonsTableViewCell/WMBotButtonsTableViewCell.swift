import Foundation
import UIKit
import WebimClientLibraryUpdated

class WMBotButtonsTableViewCell: WMMessageTableCell {
    
    @IBOutlet var borderView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var messageTextView: UITextView!
    private let SPACING_CELL: CGFloat = 6.0
    private let SPACING_DEFAULT: CGFloat = 10.0
    
    private var buttonsStack = TagButtonsView()
    private var isCanceled = false
    
    private func emptyTheCell() {
        buttonsStack.removeFromSuperview()
        buttonsStack.clearTags()
        self.messageView.isHidden = true
        self.messageTextView.text = ""
        self.buttonView.isHidden = false
    }
    
    override func setMessage(message: Message, tableView: UITableView) {
        emptyTheCell()
        self.messageView.alpha = 0
        self.buttonView.alpha = 1
        self.message = message
        fillButtonsCell(message: message, showFullDate: true)
        buttonsStack.layoutIfNeeded()
    }
    
    override func initialSetup() -> Bool {
        messageView.backgroundColor = AppColor.accent200.getColor()
        return super.initialSetup()
    }
    
    private func fillButtonsCell(
        message: Message,
        showFullDate: Bool
    ) {
        guard let keyboard = message.getKeyboard() else { return }
        let buttonsArray = keyboard.getButtons()
        var isActive = false
        self.time?.isHidden = true
        
        isCanceled = keyboard.getState() == .canceled
        
        switch keyboard.getState() {
        case .pending:
            isActive = true
        case .canceled:
            isActive = true
        case .completed:
            isActive = false
            buttonWasSelected()
            self.messageView.alpha = 1
            return
        }
        
        var uiButtons = [UIButton]()
        for buttonsStack in buttonsArray {
            for button in buttonsStack {
                let uiButton = UIButton(type: .system),
                    buttonID = button.getID(),
                    buttonText = button.getText()
                
                uiButton.accessibilityIdentifier = buttonID
                
                uiButton.setTitle(buttonText, for: .normal)
                uiButton.isUserInteractionEnabled = isActive
                /// add buttons only with text
                guard let titleLabel = uiButton.titleLabel else {
                    continue
                }
                titleLabel.font = UIFont.systemFont(ofSize: 13.0)
                titleLabel.textAlignment = .center
                titleLabel.lineBreakMode = .byWordWrapping
                titleLabel.numberOfLines = 0
                /// button text insets
                titleLabel.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(18)
                    make.width.lessThanOrEqualToSuperview().inset(10)
                }
                
                uiButton.layer.borderWidth = 1
                uiButton.layer.borderColor = buttonBorderColor.cgColor
                uiButton.clipsToBounds = true
                uiButton.translatesAutoresizingMaskIntoConstraints = false
                uiButton.layer.cornerRadius = 20
                
                if isActive {
                    uiButton.addTarget(
                        self,
                        action: #selector(sendButton),
                        for: .touchUpInside
                    )
                }
                
                uiButton.backgroundColor = AppColor.primary3.getColor()
                uiButton.tintColor = AppColor.primary2.getColor()
                
                uiButtons.append(uiButton)
            }
        }
        buttonsStack = TagButtonsView()
        buttonView.addSubview(buttonsStack)
        buttonsStack.tagButtons = uiButtons
        cellLayoutConstraintButtons(showFullDate: showFullDate)
    }
    
    private func cellLayoutConstraintButtons(showFullDate: Bool) {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(SPACING_DEFAULT)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func buttonWasSelected() {
        guard let keyboard = message.getKeyboard() else { return }
        self.emptyTheCell()
        let buttonsArray = keyboard.getButtons()
        let response = keyboard.getResponse()
        for buttonsStack in buttonsArray {
            for button in buttonsStack {
                if button.getID() == response?.getButtonID() {
                    messageTextView.attributedText = button.getText().styleBase(.bodyMedium, color: .primary2)
                    let timeString = WMMessageTableCell.timeFormatter.string(from: message.getTime())
                    self.time?.attributedText = timeString.styleBase(.captionSmall, color: UIColor(red: 0.6, green: 0.568, blue: 0.564, alpha: 1))
                }
            }
        }
        self.sharpCorner(view: messageView, visitor: true)
        self.messageTextView.sizeToFit()
        self.messageView.sizeToFit()
        self.borderView.sizeToFit()
        self.messageView.isHidden = false
        self.time?.isHidden = false
        self.buttonView.isHidden = true
    }
    
    @objc
    private func sendButton(sender: UIButton) {
        guard let title = sender.titleLabel?.text,
              let id = sender.accessibilityIdentifier
        else { return }
        if isCanceled {
            WebimServiceController.currentSession.send(message: title)
        } else {
            let messageID = message.getID()
            sender.backgroundColor = buttonChoosenBackgroundColour
            sender.tintColor = buttonChoosenTitleColour
            print("Buttton \(title) with tag\\ID \(id) of message \(messageID) was tapped!")
            let buttonInfoDictionary = [
                "Message": messageID,
                "ButtonID": id,
                "ButtonTitle": title
            ]
            sendKeyboardRequest(keyboardRequest: buttonInfoDictionary)
            
            UIView.animate(withDuration: 1,
                           animations: { [weak self] in
                self?.messageView.alpha = 1
                self?.buttonView.alpha = 0
            }, completion: { (finished: Bool) in
                self.buttonWasSelected()
            })
        }
        
    }
}


class TagButtonsView: UIView {
    
    var tagButtons: [UIButton] = [] {
        didSet {
            addTagLabels()
        }
    }
    
    let tagHeight:CGFloat = 38
    let tagPadding: CGFloat = 16
    let tagSpacingX: CGFloat = 8
    let tagSpacingY: CGFloat = 8

    var intrinsicHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
    }
    
    func clearTags() {
        tagButtons.removeAll()
    }

    func addTagLabels() -> Void {
        
        // if we already have tag labels (or buttons, etc)
        //  remove any excess (e.g. we had 10 tags, new set is only 7)
        while self.subviews.count > tagButtons.count {
            self.subviews[0].removeFromSuperview()
        }
        
        for tag in tagButtons {
            addSubview(tag)
        }

        for (_, v) in zip(tagButtons, self.subviews) {
            guard let tagButton = v as? UIButton else { return }
            tagButton.frame.size.width = (tagButton.titleLabel?.intrinsicContentSize.width ?? 0) + tagPadding
            tagButton.frame.size.height = tagHeight
        }

    }
    
    func displayTagLabels() {
        
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0

        // for each label in the array
        self.subviews.forEach { v in
            
            guard let tagButton = v as? UIButton else { return }

            // if current X + label width will be greater than container view width
            //  "move to next row"
            if currentOriginX + tagButton.frame.width > bounds.width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            // set the btn frame origin
            tagButton.frame.origin.x = currentOriginX
            tagButton.frame.origin.y = currentOriginY
            
            tagButton.frame.size.width = tagButton.frame.width > 40 ? tagButton.frame.width : 40
            
            // increment current X by btn width + spacing
            currentOriginX += tagButton.frame.width + tagSpacingX
        }
        
//        subviews.last?.snp.remakeConstraints{ make in
//            make.bottom.equalToSuperview()
//        }
        
        // update intrinsic height
        intrinsicHeight = currentOriginY + tagHeight
        invalidateIntrinsicContentSize()
        
    }

    // allow this view to set its own intrinsic height
    override var intrinsicContentSize: CGSize {
        var sz = super.intrinsicContentSize
        sz.height = intrinsicHeight
        return sz
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayTagLabels()
    }
    
}

import MobileCoreServices
import UIKit
import Nuke
import WebimClientLibraryUpdated

public class ChatViewController: UIViewController, WMToolbarBackgroundViewDelegate, DepartmentListHandlerDelegate {
    
    var popupActionsViewController: PopupActionsViewController?
    
    private var alreadyPutTextFromBufferString = false
    private var textInputTextViewBufferString: String?
    private var rateOperatorID: String?
    let newRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var headerView: ChatHeaderView!
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    
    var selectedMessage: Message?
    var scrollButtonIsHidden = true
    var surveyCounter = -1
    var shouldAdjustForKeyboard: Bool = false
    var canReloadRows = false
    // MARK: - Private properties
    
    var alreadyRatedOperators = [String: Bool]()
    var cellHeights = [IndexPath: CGFloat]()
    private var overlayWindow: UIWindow?
    private var visibleRows = [IndexPath]()
    private var scrollToBottom = false
    
    private var backButtonDidPressComplition: (() -> ())?
    
    var rateStarsViewController: RateStarsViewController?
    var surveyCommentViewController: SurveyCommentViewController?
    var surveyRadioButtonViewController: SurveyRadioButtonViewController?
    
    var chatMessages = [Message]() {
        willSet {
            if newValue.count != chatMessages.count {
                canReloadRows = false
            }
            if webimServerSideSettingsManager.disablingMessageInputField() {
                let isEnabled = newValue.last?.getType() != .keyboard
                toolbarView.messageView.messageText.isEditable = isEnabled
                toolbarView.messageView.fileButton.isEnabled = isEnabled
            }
        }
    }
    
    var searchMessages = [Message]()
    var showSearchResult = false
    
    var hideKeyboardOnScrollEnabled = false
    lazy var alertDialogHandler = UIAlertHandler(delegate: self)
    var delayedSurvayQuestion: SurveyQuestion?
    
    private lazy var filePicker = FilePicker(presentationController: self, delegate: self)

    let webimServerSideSettingsManager = WebimServerSideSettingsManager()
    lazy var messageCounter = MessageCounter(delegate: self)
    
    // MARK: - Constraints
    let buttonWidthHeight: CGFloat = 20
    let fileButtonLeadingSpacing: CGFloat = 20
    let fileButtonTrailingSpacing: CGFloat = 10
    let textInputBackgroundViewTopBottomSpacing: CGFloat = 8
    
    // MARK: - Outletls
    @IBOutlet var toolbarBackgroundView: WMToolbarBackgroundView!
    @IBOutlet var toolbarView: WMToolbarView!
    @IBOutlet var messagesTableViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Constants
    lazy var keychainKeyRatedOperators = "alreadyRatedOperators"

    // MARK: - Subviews
    // Scroll button
    lazy var scrollButtonView: ScrollButtonView = ScrollButtonView.loadXibView(forClass: ScrollButtonView.self)

    lazy var thanksView = WMThanksAlertView.loadXibView(forClass: WMThanksAlertView.self)
    lazy var connectionErrorView = ConnectionErrorView.loadXibView(forClass: ConnectionErrorView.self)
    

    // HelpersViews
    weak var cellWithSelection: WMMessageTableCell?
    
    // Bottom bar
    lazy var fileButton: UIButton = createCustomUIButton(type: .system)
    
    public override var inputAccessoryView: UIView? {
        return presentedViewController?.isBeingDismissed != false ? toolbarBackgroundView : nil
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override var canResignFirstResponder: Bool {
        return true
    }
    
    func showToolbarWithHeight(_ height: CGFloat) {}

    // MARK: - View Life Cycle
    public init(accountName: String, location: String, profile: WCProfileData?, backButtonDidPressComplition: (()->())?) {
        self.backButtonDidPressComplition = backButtonDidPressComplition
        let identifier = "\(Self.self)"
        let bundle = Bundle(for: ChatViewController.self)
        super.init(nibName: identifier, bundle: bundle)
        
        loadFonts()
        
        WebimServiceController.shared.initialize(accountName: accountName, location: location, profile: profile)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNetworkErrorView()
        configureThanksView()
        configHeader()
        configTableView()
        configureToolbarView()
        setupScrollButton()
        setupAlreadyRatedOperators()
        setupWebimSession()
        addTapGesture()

        setupRefreshControl()

        configureNotifications()
        setupServerSideSettingsManager()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WebimServiceController.shared.notFatalErrorHandler = self
        WebimServiceController.shared.departmentListHandlerDelegate = self
        WebimServiceController.shared.fatalErrorHandlerDelegate = self
        updateCurrentOperatorInfo(to: WebimServiceController.currentSession.getCurrentOperator())
        setupNavigationBar()
        shouldAdjustForKeyboard = true
        showDepartmensIfNeeded()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatTableView.scrollToRowSafe(at: IndexPath(row: messageCounter.lastReadMessageIndex, section: 0),
                                      at: .bottom,
                                      animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WMTestManager.testDialogModeEnabled = false
        updateTestModeState()
        WMKeychainWrapper.standard.setDictionary(
            alreadyRatedOperators, forKey: keychainKeyRatedOperators)
        shouldAdjustForKeyboard = false
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetNavigationControllerManager()
    }

    @available(iOS 11, *)
    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        recountNetworkErrorViewFrame()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Will not trigger method hidePopupActionsViewController()
        // if PopupActionsTableView is not presented
        self.popupActionsViewController?.hidePopupActionsViewController()
        
        coordinator.animate(
            alongsideTransition: { context in
                // Save visible rows position
                if let visibleRows = self.chatTableView?.indexPathsForVisibleRows {
                    self.visibleRows = visibleRows
                }
                context.viewController(forKey: .from)
            },
            completion: { _ in
                // Scroll to the saved position prior to screen rotate
                if let lastVisibleRow = self.visibleRows.last {
                    self.chatTableView?.scrollToRowSafe(
                        at: lastVisibleRow,
                        at: .bottom,
                        animated: true
                    )
                }
            }
        )
    }
    
    // MARK: - Methods
    @objc func dismissViewKeyboard() {
        self.toolbarView.messageView.resignMessageViewFirstResponder()
    }

    @objc func clearTextViewSelection() {
        guard let cellWithSelection = cellWithSelection else { return }
        cellWithSelection.resignTextViewFirstResponder()
        self.cellWithSelection = nil
    }
    
    // MARK: - Private methods
    private func configHeader() {
        headerView.delegate = self
    }
    
    private func configTableView() {
        chatTableView.backgroundColor = AppColor.grey40.getColor()
    }
    
    func configureToolbarView() {
        self.toolbarBackgroundView.delegate = self
        self.toolbarBackgroundView.addSubview(toolbarView)
        self.toolbarView.messageView.delegate = self
        toolbarView.setup()
    }
    
    @objc
    func titleViewTapAction(_ sender: UITapGestureRecognizer) {
        if isCurrentOperatorRated() == false {
            self.showRateOperatorDialog()
        }
    }
    
    @objc
    func updateOperatorStatus(typing: Bool, operatorStatus: String) {
        DispatchQueue.main.async { [weak self] in
            var text = ""
            if typing {
                text = "пишет...".localized()
            } else {
                text = "Поддержка TanukiFamily".localized()
            }
            self?.headerView.descriptionLabel.attributedText = text.styleBase(.caption, color: .onSurfaceP2Medium)
        }
    }
    
    @objc
    func updateOperatorInfo(operatorName: String, operatorAvatarURL: String, titleViewOperatorInfo: String, titleViewOperatorTitle: String ) {
        DispatchQueue.main.async {

            self.headerView.titleLabel.text = operatorName
            
            if operatorAvatarURL == OperatorAvatar.empty.rawValue {
                self.headerView.avatarImageView.image = UIImage.chatImageWith(named: "Avatar")
            } else if operatorAvatarURL == OperatorAvatar.placeholder.rawValue {
                self.headerView.avatarImageView.image = UIImage.chatImageWith(named: "Avatar")
            } else {
                guard let url = URL(string: operatorAvatarURL) else { return }
                
                let imageDownloadIndicator = CircleProgressIndicator()
                imageDownloadIndicator.lineWidth = 1
                imageDownloadIndicator.strokeColor = documentFileStatusPercentageIndicatorColour
                imageDownloadIndicator.isUserInteractionEnabled = false
                imageDownloadIndicator.isHidden = true
                imageDownloadIndicator.translatesAutoresizingMaskIntoConstraints = false
                
                let loadingOptions = ImageLoadingOptions(
                    placeholder: UIImage.chatImageWith(named: "Avatar"),
                    transition: .fadeIn(duration: 0.5)
                )
                let defaultRequestOptions = ImageRequestOptions()
                let imageRequest = ImageRequest(
                    url: url,
                    processors: [ImageProcessor.Circle()],
                    priority: .normal,
                    options: defaultRequestOptions
                )
                
                Nuke.loadImage(
                    with: imageRequest,
                    options: loadingOptions,
                    into: self.headerView.avatarImageView,
                    progress: { _, completed, total in
                        DispatchQueue.global(qos: .userInteractive).async {
                            let progress = Float(completed) / Float(total)
                            DispatchQueue.main.async {
                                if imageDownloadIndicator.isHidden {
                                    imageDownloadIndicator.isHidden = false
                                    imageDownloadIndicator.enableRotationAnimation()
                                }
                                imageDownloadIndicator.setProgressWithAnimation(
                                    duration: 0.1,
                                    value: progress
                                )
                            }
                        }
                    },
                    completion: { _ in
                        DispatchQueue.main.async {
                            // self.bottomBarQuoteAttachmentImageView.image = ImageCache.shared[imageRequest]
                            imageDownloadIndicator.isHidden = true
                        }
                    }
                )
            }
        }
    }
    
    @objc
    func scrollTableView(_ sender: UIButton) {
        self.scrollToBottom(animated: true)
    }

    @objc
    func scrollToUnreadMessage(_ sender: UIButton) {
        let lastReadMessageIndexPath = IndexPath(row: messageCounter.lastReadMessageIndex, section: 0)
        let firstUnreadMessageIndexPath = IndexPath(row: messageCounter.firstUnreadMessageIndex(), section: 0)
        if messageCounter.hasNewMessages() && lastReadMessageIndexPath != lastVisibleCellIndexPath() {
            chatTableView.scrollToRowSafe(at: firstUnreadMessageIndexPath,
                                          at: .bottom,
                                          animated: true)
        } else {
            self.chatTableView.layoutIfNeeded()
            self.scrollToBottom(animated: true)
        }
    }

    private func hidePlaceholderIfVisible() {
//        if !(self.textInputTextViewPlaceholderLabel.alpha == 0.0) {
//            UIView.animate(withDuration: 0.1) {
//                self.textInputTextViewPlaceholderLabel.alpha = 0.0
//            }
//        }
    }
    
    public func setConnectionStatus(connected: Bool) {
        DispatchQueue.main.async {
            self.connectionErrorView.alpha = connected ? 0 : 1
        }
    }
    
    func sendMessage(_ message: String) {
        WebimServiceController.currentSession.send(message: message) {
            self.toolbarView.messageView.setMessageText("")
            // Delete visitor typing draft after message is sent.
            WebimServiceController.currentSession.setVisitorTyping(draft: nil)
        }
    }
    
    func sendImage(image: UIImage, imageURL: URL?) {
        
        var imageData = Data()
        var imageName = String()
        var mimeType = MimeType()
        
        if let imageURL = imageURL {
            mimeType = MimeType(url: imageURL as URL)
            imageName = imageURL.lastPathComponent
            
            let imageExtension = imageURL.pathExtension.lowercased()
            
            switch imageExtension {
            case "jpg", "jpeg":
                guard let unwrappedData = image.jpegData(compressionQuality: 1.0)
                else { return }
                imageData = unwrappedData
                
            case "heic", "heif":
                guard let unwrappedData = image.jpegData(compressionQuality: 0.5)
                else { return }
                imageData = unwrappedData
                
                var components = imageName.components(separatedBy: ".")
                if components.count > 1 {
                    components.removeLast()
                    imageName = components.joined(separator: ".")
                }
                imageName += ".jpeg"
                
            default:
                guard let unwrappedData = image.pngData()
                else { return }
                imageData = unwrappedData
            }
        } else {
            guard let unwrappedData = image.jpegData(compressionQuality: 1.0)
            else { return }
            imageData = unwrappedData
            imageName = "photo.jpeg"
        }
        
        print("Webim send image, check size:", "\(imageData.count)")
        
        let maxSizeBytes = 9.8 * 1024 * 1024
        
        if imageData.count > Int(maxSizeBytes) {
            if let newImageData = compressImage(image, maxSizeBytes: Int(maxSizeBytes)) {
                imageData = newImageData
            } else {
                alertDialogHandler.showDialog(withMessage: "Максимальный размер отправляемого файла не должен превышать 10 Мб.".localized(), title: "Слишком большой файл".localized())
                return
            }
        }
        
        WebimServiceController.currentSession.send(
            file: imageData,
            fileName: imageName,
            mimeType: mimeType.value,
            completionHandler: self
        )
        scrollAfterSendFile()
    }
    
    private func compressImage(_ image: UIImage, maxSizeBytes: Int) -> Data? {
        var compressionQuality: CGFloat = 0.8
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        while let data = imageData, data.count > maxSizeBytes {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
            
            if compressionQuality <= 0.4 {
                return nil
            }
        }
        
        return imageData
    }
    
    
    func sendFile(file: Data, fileURL: URL?) {
        var url = fileURL ?? URL(fileURLWithPath: "document.pdf")
        WebimServiceController.currentSession.send(
            file: file,
            fileName: url.lastPathComponent,
            mimeType: MimeType(url: url).value,
            completionHandler: self
        )
    }
    
    func scrollAfterSendFile() {
        var safeAreaInsets = 0.0
        if #available(iOS 11.0, *) {
            safeAreaInsets = view.safeAreaInsets.bottom
        }
        self.scrollToBottom(animated: true)
        self.chatTableView.contentInset.bottom = safeAreaInsets + toolbarBackgroundView.frame.height
    }
    
    func replyToMessage(_ message: String) {
        guard let messageToReply = selectedMessage else { return }
        WebimServiceController.currentSession.reply(
            message: message,
            repliedMessage: messageToReply,
            completion: {
                // Delete visitor typing draft after message is sent.
                WebimServiceController.currentSession.setVisitorTyping(draft: nil)
            }
        )
    }
    
    @objc
    func copyMessage() {
        guard let messageToCopy = selectedMessage else { return }
        UIPasteboard.general.string = messageToCopy.getText()
    }
    
    func editMessage(_ message: String) {
        guard let messageToEdit = selectedMessage else { return }
        WebimServiceController.currentSession.edit(
            message: messageToEdit,
            text: message,
            completionHandler: self
        )
    }
    
    func reactMessage(reaction: ReactionString) {
        guard let messageToReact = selectedMessage else { return }
        WebimServiceController.currentSession.react(
            reaction: reaction,
            message: messageToReact,
            completionHandler: self
        )
    }
    
    @objc
    func deleteMessage() {
        guard let messageToDelete = selectedMessage else { return }
        WebimServiceController.currentSession.delete(
            message: messageToDelete,
            completionHandler: self
        )
    }
    
    @objc
    func scrollToBottom(animated: Bool) {
        if messages().isEmpty {
            return
        }
        
        let row = (chatTableView.numberOfRows(inSection: 0)) - 1
        let bottomMessageIndex = IndexPath(row: row, section: 0)
        chatTableView?.scrollToRowSafe(at: bottomMessageIndex, at: .bottom, animated: animated)
    }
    
    @objc
    func scrollToTop(animated: Bool) {
        if messages().isEmpty {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.chatTableView?.scrollToRowSafe(at: indexPath, at: .top, animated: animated)
    }

    func reloadTableWithNewData() {
        self.chatTableView?.reloadData()
        canReloadRows = true
    }

    // MARK: - Private methods
    @objc
    func requestMessages() {
        WebimServiceController.currentSession.getNextMessages { [weak self] messages in
            DispatchQueue.main.async {
                self?.chatMessages.insert(contentsOf: messages, at: 0)
                self?.messageCounter.increaseLastReadMessageIndex(with: messages.count)

                self?.reloadTableWithNewData()
                self?.chatTableView.layoutIfNeeded()
                if self?.scrollToBottom == true {
                    self?.scrollToBottom(animated: false)
                    self?.scrollToBottom = false
                }
                
                self?.updateCurrentOperatorInfo(to: WebimServiceController.currentSession.getCurrentOperator())
                
                self?.newRefreshControl.endRefreshing()
            }
        }
    }
    
    func shouldShowFullDate(forMessageNumber index: Int) -> Bool {
        guard index - 1 >= 0 else { return true }
        let currentMessageTime = chatMessages[index].getTime()
        let previousMessageTime = chatMessages[index - 1].getTime()
        let differenceBetweenDates = Calendar.current.dateComponents(
            [.day],
            from: previousMessageTime,
            to: currentMessageTime
        )
        return differenceBetweenDates.day != 0
    }
    
    func shouldShowOperatorInfo(forMessageNumber index: Int) -> Bool {
        guard chatMessages[index].isOperatorType() else { return false }
        guard index + 1 < chatMessages.count else { return true }
        
        let nextMessage = chatMessages[index + 1]
        let progress = nextMessage.getData()?.getAttachment()?.getDownloadProgress() ?? 100
        if nextMessage.isOperatorType() {
            return progress != 100
        } else {
            return true
        }
    }
    
    func showPopover(cell: UITableViewCell, message: Message, cellHeight: CGFloat) {
        
        let viewController = PopupActionsViewController()
        self.popupActionsViewController = viewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.cellImageViewImage = cell.contentView.takeScreenshot()
        viewController.delegate = self
        UIImageView.animate(withDuration: 0.2, animations: {() -> Void in
            viewController.cellImageView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        })
        guard let globalYPosition = cell.superview?
                .convert(cell.center, to: nil)
        else { return }
        viewController.cellImageViewCenterYPosition = globalYPosition.y
        viewController.cellImageViewHeight = cellHeight
        if message.isOperatorType() {
            viewController.originalCellAlignment = .leading
        } else if message.isVisitorType() {
            viewController.originalCellAlignment = .trailing
        }

        if webimServerSideSettingsManager.isGlobalReplyEnabled() && message.canBeReplied() {
             viewController.actions.append(.reply)
        }
        
        if message.canBeCopied() {
            viewController.actions.append(.copy)
        }

        if webimServerSideSettingsManager.isMessageEditEnabled() && message.canBeEdited() {
            if message.getData()?.getAttachment() == nil {
                viewController.actions.append(.edit)
            }
            viewController.actions.append(.delete)
        }
        
        if message.canVisitorReact() {
            if message.getVisitorReaction() == nil || message.canVisitorChangeReaction() {
                viewController.actions.append(.like)
                viewController.actions.append(.dislike)
            }
        }
        
        if !viewController.actions.isEmpty {
            WebimServiceController.keyboardHidden(true)
            let scale = (self.view.frame.width + 19) / self.view.frame.width
            self.present(viewController, animated: false) {
                UIImageView.animate(withDuration: 0.2, animations: {() -> Void in
                    viewController.cellImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
                })
            }
        }
    }
    
    func showOverlayWindow() {
        
        if WebimServiceController.keyboardWindow != nil {
            overlayWindow?.isHidden = false
        }
        WebimServiceController.keyboardHidden(true)
    }
    
    @objc
    func rateOperatorByTappingAvatar(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let tapLocation = recognizer.location(in: chatTableView)
        
        guard let tapIndexPath = chatTableView?.indexPathForRow(at: tapLocation) else { return }
        let message = messages()[tapIndexPath.row]
        
        self.showRateOperatorDialog(operatorId: message.getOperatorID())
    }
    
    @objc
    private func addRatedOperator(_ notification: Notification) {
        guard let ratingInfoDictionary = notification.userInfo
                as? [String: Int]
        else { return }
        
        for (id, rating) in ratingInfoDictionary {
            rateOperator(
                operatorID: id,
                rating: rating
            )
        }
    }
    
    // Webim methods
    private func setupWebimSession() {
        WebimServiceController.shared.stopSession()
        WebimServiceController.currentSession.setMessageTracker(withMessageListener: self)
        WebimServiceController.currentSession.set(operatorTypingListener: self)
        WebimServiceController.currentSession.set(currentOperatorChangeListener: self)
        WebimServiceController.currentSession.set(chatStateListener: self)
        WebimServiceController.currentSession.set(surveyListener: self)
        WebimServiceController.currentSession.set(unreadByVisitorMessageCountChangeListener: messageCounter)
        WebimServiceController.currentSession.getLastMessages { [weak self] messages in
            

            DispatchQueue.main.async {
                self?.chatMessages.insert(contentsOf: messages, at: 0)
                if messages.count < WebimService.ChatSettings.messagesPerRequest.rawValue {
                    self?.scrollToBottom = true
                    self?.requestMessages()
                } else {
                    self?.reloadTableWithNewData()
                    self?.scrollToBottom(animated: false)
                    self?.scrollToBottom = false
                }
            }
        }
    }
    
    func updateCurrentOperatorInfo(to newOperator: Operator?) {

        if let currentOperator = newOperator {

            let operatorURLString = currentOperator.getAvatarURL()?.absoluteString ?? OperatorAvatar.placeholder.rawValue
            updateOperatorInfo(operatorName: currentOperator.getName(),
                               operatorAvatarURL: operatorURLString,
                               titleViewOperatorInfo: currentOperator.getInfo() ?? "",
                               titleViewOperatorTitle: currentOperator.getTitle() ?? "")
        } else {
            updateOperatorInfo(operatorName: "Webim chat".localized,
                               operatorAvatarURL: OperatorAvatar.empty.rawValue,
                               titleViewOperatorInfo: "",
                               titleViewOperatorTitle: "")
        }
    }

    private func resetNavigationControllerManager() {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = .zero
        }
//        navigationControllerManager.reset()
    }

    private func showDepartmensIfNeeded() {
        if let departmentList = WebimServiceController.currentSession.departmentList(),
           WebimServiceController.currentSession.shouldShowDepartmentSelection() {
            showDepartmentsList(departmentList) { departmentKey in
                WebimServiceController.currentSession.startChat(departmentKey: departmentKey, message: nil)
            }
        }
    }
    
    // MARK: - WEBIM: DepartmentListHandlerDelegate
    func showDepartmentsList(_ departaments: [Department], action: @escaping (String) -> Void) {
        alertDialogHandler.showDepartmentListDialog(
            withDepartmentList: departaments,
            action: action,
            sourceView: toolbarView,
            cancelAction: { }
        )
    }

    func updateScrollButtonConstraints(_ inset: CGFloat) {
        scrollButtonView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(inset)
        }
        scrollButtonView.layoutIfNeeded()
    }

    private func updateScrollButtonView() {
        messageCounter.set(lastReadMessageIndex: lastVisibleCellIndexPath()?.row ?? 0)
        let state: ScrollButtonViewState = messageCounter.hasNewMessages() ?
            .newMessage : isLastCellVisible() || chatMessages.isEmpty ? .hidden : .visible
        scrollButtonView.setScrollButtonViewState(state)
    }
}

extension ChatViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollButtonView()
    }

    func recountChatTableFrame(keyboardHeight: CGFloat) -> CGRect {

        let offset = max(keyboardHeight, self.toolbarView.frame.height )
        let height = self.view.frame.height - self.chatTableView.frame.origin.y - offset
        var newFrame = self.chatTableView.frame
        newFrame.size.height = height
        return newFrame
    }

    func recountTableSize() {
        let newFrame = recountChatTableFrame(keyboardHeight: 0)
        self.chatTableView.frame = newFrame
        var scrollButtonFrame = self.scrollButtonView.frame
        scrollButtonFrame.origin.y = newFrame.size.height - 50
        self.scrollButtonView.frame = scrollButtonFrame
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }

    func isLastCellVisible() -> Bool {
        guard let lastVisibleCell = chatTableView.visibleCells.last else { return false }
        let lastIndexPath = chatTableView.indexPath(for: lastVisibleCell)
        return lastIndexPath?.row == messages().count - 1
    }

    func lastVisibleCellIndexPath() -> IndexPath? {
        guard let lastVisibleCell = chatTableView.visibleCells.last else { return nil }
        let lastIndexPath = chatTableView.indexPath(for: lastVisibleCell)
        return lastIndexPath
    }
}

// MARK: - FilePickerDelegate methods
extension ChatViewController: FilePickerDelegate {
    
    public func didSelect(images: [ImageToSend]) {
        for image in images {
            print("didSelect(image: \(String(describing: image.url?.lastPathComponent)), imageURL: \(String(describing: image.url)))")
            guard let imageToSend = image.image else { return }
            self.sendImage(image: imageToSend, imageURL: image.url)
        }
    }
    
    public func didSelect(files: [FileToSend]) {
        for file in files {
            print("didSelect(file: \(file.url?.lastPathComponent ?? "nil")), fileURL: \(file.url?.path ?? "nil"))")
            guard let fileToSend = file.file else { return }
            self.sendFile(file: fileToSend,fileURL: file.url)
        }
    }
}

//extension ChatViewController: ChatTestViewDelegate {
//
//    func getSearchMessageText() -> String {
//        let searchText = self.toolbarView.messageView.getMessage()
//        self.toolbarView.messageView.setMessageText("")
//        return searchText
//    }
//
//    func toogleAutotest() -> Bool {
//        return self.toggleAutotest()
//    }
//
//    func showSearchResult(searcMessages: [Message]?) {
//        showSearchResult(messages: searcMessages)
//    }
//    
//    func clearHistory() {
//        removedAllMessages()
//    }
//}

extension ChatViewController: WMNewMessageViewDelegate {
    func inputTextChanged() {
        self.view.layoutIfNeeded()
        WebimServiceController.currentSession.setVisitorTyping(draft: self.toolbarView.messageView.getMessage())
    }
    
    func sendMessage() {
        let messageText = self.toolbarView.messageView.getMessage()
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        if self.toolbarView.quoteBarIsVisible() {
            if self.toolbarView.quoteView.currentMode() == .edit {
                if messageText.trimmingCharacters(in: .whitespacesAndNewlines) !=
                    self.toolbarView.quoteView.currentMessage().trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.editMessage(messageText)
                }
            } else {
                self.replyToMessage(messageText)
            }
            self.toolbarView.removeQuoteEditBar()
        } else {
            self.sendMessage(messageText)
        }
        self.scrollToBottom(animated: true)
        self.toolbarView.messageView.setMessageText("")
        self.selectedMessage = nil
    }
    
    func showSendFileMenu(_ sender: UIButton) { // Send file button pressed
        filePicker.showSendFileMenu(from: sender)
    }
}

extension ChatViewController: MessageCounterDelegate {
    func changed(newMessageCount: Int) {
        var state: ScrollButtonViewState

        if newMessageCount > 0 && !isLastCellVisible() {
            state = .newMessage
            scrollButtonView.setNewMessageCount(newMessageCount)
        } else if newMessageCount == 0 && !isLastCellVisible() {
            state = .visible
        } else {
            state = .hidden
            WebimServiceController.currentSession.setChatRead()
        }
        scrollButtonView.setScrollButtonViewState(state)
    }

    func updateLastMessageIndex(completionHandler: ((Int) -> ())?) {
        completionHandler?(messages().count - 1)
    }

    func updateLastReadMessageIndex(completionHandler: ((Int) -> ())?) {
        completionHandler?(lastVisibleCellIndexPath()?.row ?? 0)
    }
}

extension ChatViewController: TopHeaderViewDelegate {
    
    func backButtonDidPress() {
        backButtonDidPressComplition?()
    }
}

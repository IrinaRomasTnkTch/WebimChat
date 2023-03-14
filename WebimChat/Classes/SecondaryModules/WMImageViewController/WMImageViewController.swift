import UIKit
import Nuke

class WMImageViewController: UIViewController {

    // MARK: - Properties
    var selectedImage: UIImage?
    var selectedImageURL: URL?
    
    // MARK: - Private properties
    private lazy var alertDialogHandler = UIAlertHandler(delegate: self)
    private lazy var imageDownloadIndicator: CircleProgressIndicator = {
        let indicator = CircleProgressIndicator()
        indicator.lineWidth = 1
        indicator.strokeColor = documentFileStatusPercentageIndicatorColour
        indicator.isUserInteractionEnabled = false
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var chatFleHeaderView: ChatFileHeaderView!
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.reloadImageIfNeed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatFleHeaderView.backgroundColor = AppColor.primary2.getColor()
        chatFleHeaderView.backButton.imageView?.tintColor = AppColor.primary3.getColor()
        chatFleHeaderView.downloadButton.imageView?.tintColor = AppColor.primary3.getColor()
        chatFleHeaderView.delegate = self
        chatFleHeaderView.downloadButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        imageView.isUserInteractionEnabled = true
        
        if let imageToLoad = selectedImage {
            imageView.image = imageToLoad
        }
        
        addGestures()
    }

    // MARK: - Private methods
    private func reloadImageIfNeed() {
        guard selectedImage == nil,
            let url = selectedImageURL else { return }
        let request = ImageRequest(url: url)

        if let image = ImageCache.shared[request] {
            self.selectedImage = image
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        } else {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(named: "image_placeholder")
                self.imageView.addSubview(self.imageDownloadIndicator)
                self.imageDownloadIndicator.snp.remakeConstraints { (make) -> Void in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(45)
                    make.width.equalTo(45)
                }
                
                Nuke.ImagePipeline.shared.loadImage(
                    with: url,
                    progress: { _, completed, total in
                        DispatchQueue.global(qos: .userInteractive).async {
                            self.updateImageDownloadProgress(
                                completed: completed,
                                total: total
                            )
                        }
                    },
                    completion: { _ in
                        DispatchQueue.main.async {
                            self.selectedImage = ImageCache.shared[request]
                            self.imageView.image = ImageCache.shared[request]
                            self.imageDownloadIndicator.isHidden = true
                        }
                    }
                )
            }
        }
    }
    
    @objc
    private func saveButtonTapped(sender: UIBarButtonItem) {
        guard let imageToSave = selectedImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(
            imageToSave,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc
    private func image(
        _ image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error {
            // Save error
            alertDialogHandler.showImageSavingFailureDialog(withError: error)
        } else {
            let saveView = WMSaveView.loadXibView()
            self.view.addSubview(saveView)
            saveView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            saveView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.view.bringSubviewToFront(saveView)
            saveView.animateImage()
        }
    }
    
    private func addGestures() {
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGesture)
        )
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        imageView.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinchGesture)
        )
        imageView.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(
            target: self,
            action: #selector(rotateGesture)
        )
        imageView.addGestureRecognizer(rotate)
    }
    
    @objc
    private func panGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            
            guard let view = sender.view else { return }
            let translation = sender.translation(in: view.superview)
            let transform = CGAffineTransform(
                translationX: translation.x,
                y: translation.y
            )
            imageView.transform = transform
            
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.imageView.transform = CGAffineTransform.identity
                }
            )
            
            let velocity = sender.velocity(in: view)
            
            guard velocity.y >= 1500 else { return }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func pinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard let view = sender.view else { return }
        
            let pinchCenter = CGPoint(
                x: sender.location(in: view).x - view.bounds.midX,
                y: sender.location(in: view).y - view.bounds.midY
            )
            
            let transform = view.transform
                .translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            var newScale = currentScale * sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale,
                                                  y: newScale)
                imageView.transform = transform
                sender.scale = 1
            } else {
                view.transform = transform
                sender.scale = 1
            }
            
        } else
            if sender.state == .ended ||
            sender.state == .failed ||
            sender.state == .cancelled {
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.imageView.transform = CGAffineTransform.identity
                }
            )
        }
    }
    
    @objc
    private func rotateGesture (sender: UIRotationGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard sender.view != nil else { return }
            let transform = CGAffineTransform(rotationAngle: sender.rotation)
            
            imageView.transform = transform
        } else
            if sender.state == .ended ||
                sender.state == .failed ||
                sender.state == .cancelled {
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.imageView.transform = CGAffineTransform.identity
                }
            )
    
        }
    }
    
    private func updateImageDownloadProgress(completed: Int64, total: Int64) {
        let progress = Float(completed) / Float(total)
        DispatchQueue.main.async {
            if self.imageDownloadIndicator.isHidden {
                self.imageDownloadIndicator.isHidden = false
                self.imageDownloadIndicator.enableRotationAnimation()
            }
            self.imageDownloadIndicator.setProgressWithAnimation(
                duration: 0.1,
                value: progress
            )
        }
    }
}

extension WMImageViewController: TopHeaderViewDelegate {
    
    func backButtonDidPress() {
//        if AppRouter.navigationContain(viewController: self) {
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            bottomSheetControl?.dismissAnimatedBottomSheetViewController(completion: nil)
//        }
    }
}

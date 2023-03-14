import AVFoundation
import UIKit

protocol RateStarsViewControllerDelegate: AnyObject {
    
    func rateOperator(operatorID: String, rating: Int)
}

class RateStarsViewController: WMSurveyViewController {
    
    // MARK: - Init Properties
    weak var rateOperatorDelegate: RateStarsViewControllerDelegate?
    var operatorId = String()
    var operatorRating = 0
    var isSurvey = false
    var descriptionText: String?

    // MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var starsButtonsView: StarsButtonsView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        backgroundView.layer.cornerRadius = 8
        
        let text = isSurvey ? descriptionText : "Пожалуйста, оцените работу оператора".localized
        descriptionLabel.attributedText = text?.styleBase(.bodyBold, color: .primary2)
        
        self.disableSendButton()
        
        rateButtonsBaseSettings()
        starsButtonsView.rateAction(rate: operatorRating)
        
        sendButton.layer.cornerRadius = 24
        sendButton.setTitle("Отправить".localized, for: .normal)
        sendButton.titleLabel?.font = AppStyleText.bodyBold.getFont()
        sendButton.setTitleColor(UIColor(red: 0.18, green: 0.174, blue: 0.173, alpha: 1), for: .disabled)
        sendButton.setTitleColor(AppColor.onSurfaceP3High.getColor(), for: .normal)
        sendButton.setBackgroundColor(AppColor.onSurfaceP2High.getColor(), forState: .normal)
        sendButton.setBackgroundColor(AppColor.grey50.getColor(), forState: .disabled)
        sendButton.isEnabled = operatorRating > 0
    }
    
    func rateButtonsBaseSettings () {
        starsButtonsView.rateButtonsBaseSettings()
        starsButtonsView.star1Button.addTarget(self, action: #selector(star1DidTap), for: .touchUpInside)
        starsButtonsView.star2Button.addTarget(self, action: #selector(star2DidTap), for: .touchUpInside)
        starsButtonsView.star3Button.addTarget(self, action: #selector(star3DidTap), for: .touchUpInside)
        starsButtonsView.star4Button.addTarget(self, action: #selector(star4DidTap), for: .touchUpInside)
        starsButtonsView.star5Button.addTarget(self, action: #selector(star5DidTap), for: .touchUpInside)
    }
    
    func rateAction(rate: Int) {
        starsButtonsView.rateAction(rate: rate)
        operatorRating = rate
        sendButton.isEnabled = rate > 0
    }
    
    @objc func star1DidTap() {
        rateAction(rate: 1)
    }
    
    @objc func star2DidTap() {
        rateAction(rate: 2)
    }
    
    @objc func star3DidTap() {
        rateAction(rate: 3)
    }
    
    @objc func star4DidTap() {
        rateAction(rate: 4)
    }
    
    @objc func star5DidTap() {
        rateAction(rate: 5)
    }

    @IBAction func sendRate(_ sender: Any) {
        let rating = Int(operatorRating)
        
        if isSurvey {
            self.delegate?.sendSurveyAnswer("\(rating)")
        } else {
            self.rateOperatorDelegate?.rateOperator(operatorID: self.operatorId, rating: rating)
        }
        
        self.close(nil)
    }
}

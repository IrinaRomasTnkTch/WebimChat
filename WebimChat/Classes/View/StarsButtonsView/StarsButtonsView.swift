import UIKit

class StarsButtonsView: BaseNibView {
    
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rateButtonsBaseSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rateButtonsBaseSettings()
    }
    
    func rateButtonsBaseSettings () {
        star1Button.tag = 1
        star2Button.tag = 2
        star3Button.tag = 3
        star4Button.tag = 4
        star5Button.tag = 5
        let rateButtons: [UIButton] = [star1Button, star2Button, star3Button, star4Button, star5Button]
        for button in rateButtons {
            button.tintColor = AppColor.grey60.getColor()
        }
    }
    
    func rateAction(rate: Int) {
        let rateButtons: [UIButton] = [star1Button, star2Button, star3Button, star4Button, star5Button]
        for (n, button) in rateButtons.enumerated() {
            if( n < rate) {
                button.tintColor = AppColor.feedBackStarActive.getColor()
            } else {
                button.tintColor = AppColor.grey60.getColor()
            }
        }
    }
}

import UIKit

class StarsButtonsView: UIView {
    
    let star1Button = UIButton()
    let star2Button = UIButton()
    let star3Button = UIButton()
    let star4Button = UIButton()
    let star5Button = UIButton()
    let stackView = UIStackView()
    
    func rateButtonsBaseSettings () {
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(64)
            make.height.equalToSuperview()
        }
        
        stackView.addArrangedSubview(star1Button)
        stackView.addArrangedSubview(star2Button)
        stackView.addArrangedSubview(star3Button)
        stackView.addArrangedSubview(star4Button)
        stackView.addArrangedSubview(star5Button)
        
        star1Button.tag = 1
        star2Button.tag = 2
        star3Button.tag = 3
        star4Button.tag = 4
        star5Button.tag = 5
        
        let rateButtons: [UIButton] = [star1Button, star2Button, star3Button, star4Button, star5Button]
        for button in rateButtons {
            button.setImage(UIImage.chatImageWith(named: "rate")?.withRenderingMode(.alwaysTemplate), for: .normal)
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

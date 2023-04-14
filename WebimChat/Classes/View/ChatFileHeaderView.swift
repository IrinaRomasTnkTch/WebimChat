import UIKit

class ChatFileHeaderView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrow_back_ios-24px")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = AppColor.onSurfaceP2High.getColor()
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ImageDownload")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = AppColor.onSurfaceP2High.getColor()
        return button
    }()
    

    weak var delegate: TopHeaderViewDelegate?
    
    override func layoutSubviews() {
        renderSubviews()
        
        backButton.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
    }
    
    private func renderSubviews() {
        self.addSubview(backButton)
        self.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 23),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            downloadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -23),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc private func backButtonHandler() {
        delegate?.backButtonDidPress()
    }
}

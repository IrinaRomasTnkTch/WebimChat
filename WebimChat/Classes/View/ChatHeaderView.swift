import UIKit

class ChatHeaderView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrow_back_ios-24px")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = AppColor.onSurfaceP2High.getColor()
        return button
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStyleText.title3.getFont()
        label.textColor = AppColor.primary2.getColor()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStyleText.title3.getFont()
        label.textColor = AppColor.onSurfaceP2High.getColor()
        label.attributedText = "Поддержка TanukiFamily".localized().styleBase(.caption, color: .onSurfaceP2Medium)
        return label
    }()
    
    private let deviderLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.grey50.getColor()
        return view
    }()
    
    weak var delegate: TopHeaderViewDelegate?
    
    override func layoutSubviews() {
        renderSubviews()
        
        backButton.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
    }
    
    private func renderSubviews() {
        
        self.backgroundColor = AppColor.primary3.getColor()
        
        self.addSubview(backButton)
        self.addSubview(avatarImageView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(deviderLine)
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 23),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),

            deviderLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            deviderLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            deviderLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deviderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    @objc private func backButtonHandler() {
        delegate?.backButtonDidPress()
    }
}

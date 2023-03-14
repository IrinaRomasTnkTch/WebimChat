import UIKit

class BaseNibView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
        baseSettingSelf()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initContentView()
        baseSettingSelf()
    }
    
    private func initContentView() {
        let nib = UINib(nibName: "\(type(of: self))", bundle: Bundle(for: type(of: self)))
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func baseSettingSelf() {
        self.backgroundColor = AppColor.clear.getColor()
        self.contentView.backgroundColor = AppColor.clear.getColor()
    }
    
}


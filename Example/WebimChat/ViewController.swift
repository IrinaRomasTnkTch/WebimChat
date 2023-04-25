import UIKit
import WebimChat

class ViewController: UIViewController {
    
    var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        button.setTitle("Touch", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(touchBtn), for: .touchUpInside)
        
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.center = view.center
        
        view.addSubview(button)
        
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func touchBtn() {
        let profileData = WCProfileData(id: 0, name: "Name", surname: "Nemov", phone: "79555555555", email: nil)
        let chat = ChatViewController(accountName: "demo", location: "mobile", profile: profileData, backButtonDidPressComplition: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        navigationController?.pushViewController(chat, animated: true)
    }
    

}


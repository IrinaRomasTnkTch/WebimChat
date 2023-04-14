import UIKit
import WebimChat

class ViewController: UIViewController {
    
    var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        
        
        button.setTitle("Touch", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(touchBtn), for: .touchUpInside)
        
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func touchBtn() {
//        let chat = ChatViewController()
        let chat = ChatViewController.loadViewControllerFromXib(bundle: ChatViewController.self)
////        let chat = ChatViewControllerTest.loadViewControllerFromXib(bundle: ChatViewController.self)
////        let chat = XibViewController.loadViewControllerFromXib(bundle: XibViewController.self)
        navigationController?.pushViewController(chat, animated: true)
    }
    

}


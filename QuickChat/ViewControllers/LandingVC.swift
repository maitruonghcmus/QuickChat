import UIKit

class LandingVC: UIViewController {
    
    //Set app alway display as portrait (dont rotate)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //Check user sign in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
        
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .tabbar)
                    } else {
                        weakSelf?.pushTo(viewController: .login)
                    }
                    weakSelf = nil
                }
            })
        }
        else {
            self.pushTo(viewController: .login)
        }
    }
    
    //Push to ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .tabbar:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
            self.present(vc, animated: false, completion: nil)
        case .login:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: false, completion: nil)
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: false, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

import UIKit
import Firebase

class ProfileVC: UIViewController {

    //MARK: *** Variable
    //MARK: *** UI Elements
    //MARK: *** Custom Functions
    //MARK: *** UI Events
    //MARK: *** View
    //MARK: *** Table View
    
    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnLogout: RoundedButton!
    
    func setLanguague(){
        DispatchQueue.main.async {
            self.navigationItem.title = MultiLanguague.profileItem
            self.btnLogout.setTitle(MultiLanguague.profileBtnLogout, for: .normal)
        }
        
        //self.setLanguague(lang: MultiLanguague.languague)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setLanguague()
    }

    
    //Downloads current user credentials
    func fetchUserInfo() {
        if let id = FIRAuth.auth()?.currentUser?.uid {
            User.info(forUserID: id, completion: {[weak weakSelf = self] (user) in DispatchQueue.main.async {
                    weakSelf?.lblName.text = user.name
                    weakSelf?.lblEmail.text = user.email
                    weakSelf?.imgProfile.image = user.profilePic
                    weakSelf = nil
                }
            })
        }
    }
    
    @IBAction func btnLogOut_Tapped(_ sender: Any) {
        User.logOutUser { (status) in
            if status == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

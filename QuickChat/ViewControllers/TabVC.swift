import UIKit

class TabVC: UITabBarController {
    
    //MARK: *** Variable
    //MARK: *** UI Elements
    //MARK: *** Custom Functions
    //MARK: *** UI Events
    //MARK: *** View
    //MARK: *** Table View
    
    func setLanguague(){
        DispatchQueue.main.async {
            self.tabBar.items?[0].title = MultiLanguague.messageItem
            self.tabBar.items?[1].title = MultiLanguague.contactItem
            self.tabBar.items?[2].title = MultiLanguague.profileItem
            self.tabBar.items?[3].title = MultiLanguague.settingTitle
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLanguague()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

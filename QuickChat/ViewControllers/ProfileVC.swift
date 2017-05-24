//
//  ProfileVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/24/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
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

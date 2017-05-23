//
//  LoginVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/23/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    
    // MARK: - Custom func
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
        self.show(vc, sender: nil)
    }

    // MARK: - Event
 
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSignIn_Tapped(_ sender: Any) {
        User.loginUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) {
            [weak weakSelf = self](status) in DispatchQueue.main.async {
                
                if status == true {
                    weakSelf?.pushTomainView()
                } else {
                    self.lblMessage.isHidden = false
                }
                weakSelf = nil
            }
        }
    }
}

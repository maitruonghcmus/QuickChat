//
//  LoginVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/23/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: *** Variable
    //MARK: *** UI Elements
    //MARK: *** Custom Functions
    //MARK: *** UI Events
    //MARK: *** View
    //MARK: *** Table View
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSignIn_Tapped(_ sender: Any) {
        User.loginUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) {
            [weak weakSelf = self](status) in DispatchQueue.main.async {
                if status == true {
                    Other.get(completion: {(ok) in
                        self.pushTomainView()
                    })
                } else {
                    self.lblMessage.isHidden = false
                }
                weakSelf = nil
            }
        }
    }
}

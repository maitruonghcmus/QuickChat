//
//  LoginVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/23/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import LocalAuthentication

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
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withEmail: email, password: password) {
                [weak weakSelf = self](status) in DispatchQueue.main.async {
                    if status == true {
                        let authenticationContext = LAContext()
                        var policy: LAPolicy?
                        // Depending the iOS version we'll need to choose the policy we are able to use
                        if #available(iOS 9.0, *) {
                            // iOS 9+ users with Biometric and Passcode verification
                            policy = .deviceOwnerAuthentication
                        } else {
                            // iOS 8+ users with Biometric and Custom (Fallback button) verification
                            authenticationContext.localizedFallbackTitle = "Fuu!"
                            policy = .deviceOwnerAuthenticationWithBiometrics
                        }
                        var error:NSError?
                        guard authenticationContext.canEvaluatePolicy(policy!, error: &error) else {
                            self.showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
                            return
                        }
                        // 3. Check the fingerprint
                        authenticationContext.evaluatePolicy(
                            policy!,
                            localizedReason: "Only awesome people are allowed",
                            reply: { [unowned self] (success, error) -> Void in
                                if( success ) {
                                    // Fingerprint recognized
                                    // Go to view controller
                                    self.pushTomainView()
                                }else {
                                    // Check if there is an error
                                    if let error = error as NSError? {
                                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                                    }
                                }
                        })
                    } else {
                        self.lblMessage.isHidden = false
                    }
                    weakSelf = nil
                }
            }
        }
    }
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        showAlertWithTitle(title: "Error", message: message)
    }
    
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
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

//
//  SettingVC.swift
//  QuickChat
//
//  Created by An Le on 6/15/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var switchTouchID: UISwitch!
    @IBOutlet weak var lblLanguague: UILabel!
    
    var isNotificationOn = false
    var isTouchIdOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchTouchID.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        switchNotification.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    func switchValueDidChange(sender:UISwitch!){
        
        if (sender == switchTouchID) {
            if sender.isOn == true {
                showInputPasscode(completion: {(ok) in
                    if ok == true {
                        Other.useTouchID = sender.isOn
                    }
                    else {
                        self.showAlertFail(title: "Error", message: "Passcode not same")
                    }
                })
            } else {
                showConfirmPasscode(completion: {(ok) in
                    if ok == true {
                        Other.useTouchID = sender.isOn
                    }
                    else {
                        self.showAlertFail(title: "Error", message: "Wrong passcode")
                    }
                })
            }
        }
        if (sender == switchNotification) {
            Other.useNotification = sender.isOn
        }
        Other.update(completion: {(ok) in
            if ok == false {
                self.showAlertFail(title: "Error", message: "Have error, please try again")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: show lock alert
    func showInputPasscode(completion: @escaping (Bool) -> Swift.Void){
        let alertController = UIAlertController(title: "Passcode", message: "Please input passcode:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if let field2 = alertController.textFields![1] as? UITextField {
                    if field.text == field2.text {
                        Other.passcode = field.text!
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
                else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Passcode:"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Confirm passcode:"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: show lock alert
    func showConfirmPasscode(completion: @escaping (Bool) -> Swift.Void){
        let alertController = UIAlertController(title: "Passcode", message: "Please input passcode:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text == Other.passcode {
                    Other.passcode = field.text!
                    completion(true)
                }
                else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Passcode:"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertFail(title: String, message:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

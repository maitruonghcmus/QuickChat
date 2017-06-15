import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var switchTouchID: UISwitch!
    @IBOutlet weak var lblLanguague: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTouchIDPasscode: UILabel?
    @IBOutlet weak var btnRestoreDefault: UIButton!
    
    
    var isNotificationOn = false
    var isTouchIdOn = false
    
    func setLanguague(lang: Int){
        MultiLanguague.languague = lang
        MultiLanguague.update()
        
        DispatchQueue.main.async {
            self.lblLanguague.text = MultiLanguague.settingLanguague
            self.lblNotification.text = MultiLanguague.settingNotification
            self.lblTouchIDPasscode?.text = MultiLanguague.settingTouchIDPasscode
            self.btnRestoreDefault.setTitle(MultiLanguague.settingRestoreDefaul, for: .normal)
            self.navigationItem.title = MultiLanguague.settingTitle
        }
        
        //TabVC().setLanguague()
    }

    @IBAction func btnEn_Tapped(_ sender: Any) {
        self.setLanguague(lang: 1)
    }
    
    @IBAction func btnVietnamese_Tapped(_ sender: Any) {
        self.setLanguague(lang: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLanguague(lang: MultiLanguague.languague)
    }
    
    
    @IBAction func btnRestoreDefault_Tapped(_ sender: Any) {
        self.setLanguague(lang: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchTouchID.setOn(Other.useTouchID, animated: true)
        switchNotification.setOn(Other.useNotification, animated: true)
        switchTouchID.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        switchNotification.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    func switchValueDidChange(sender:UISwitch!){
        
        if (sender == switchTouchID) {
            if sender.isOn == true {
                showInputPasscode(completion: {(ok) in
                    if ok == true {
                        Other.useTouchID = true
                        self.showAlertFail(title: MultiLanguague.success, message: MultiLanguague.pleaseRestart)
                    }
                    else {
                        Other.useTouchID = false
                        self.showAlertFail(title: MultiLanguague.error, message: MultiLanguague.passDoesNotMatch)
                    }
                    self.switchTouchID.setOn(Other.useTouchID, animated: true)
                    Other.update(completion: {(ok) in
                        if ok == false {
                            self.showAlertFail(title: MultiLanguague.error, message: MultiLanguague.tryAgain)
                        }
                    })
                })
            } else {
                showConfirmPasscode(completion: {(ok) in
                    if ok == true {
                        Other.useTouchID = false
                        self.showAlertFail(title: MultiLanguague.success, message: MultiLanguague.pleaseRestart)
                    }
                    else {
                        Other.useTouchID = true
                        self.showAlertFail(title: MultiLanguague.error, message: MultiLanguague.wrongPassword)
                    }
                    self.switchTouchID.setOn(Other.useTouchID, animated: true)
                    Other.update(completion: {(ok) in
                        if ok == false {
                            self.showAlertFail(title: MultiLanguague.error, message: MultiLanguague.tryAgain)
                        }
                    })
                })
            }
        }
        if (sender == switchNotification) {
            Other.useNotification = sender.isOn
            Other.update(completion: {(ok) in
                if ok == false {
                    self.showAlertFail(title: MultiLanguague.error, message: MultiLanguague.tryAgain)
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: show lock alert
    func showInputPasscode(completion: @escaping (Bool) -> Swift.Void){
        let alertController = UIAlertController(title: MultiLanguague.passcode, message: MultiLanguague.inputPasscode, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: MultiLanguague.confirm, style: .default) { (_) in
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
        
        let cancelAction = UIAlertAction(title: MultiLanguague.cancel, style: .cancel) { (_) in
            completion(false)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = MultiLanguague.passcode
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = MultiLanguague.confirmPasscode
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: show lock alert
    func showConfirmPasscode(completion: @escaping (Bool) -> Swift.Void){
        let alertController = UIAlertController(title: MultiLanguague.passcode, message: MultiLanguague.inputPasscode, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: MultiLanguague.confirm, style: .default) { (_) in
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
        
        let cancelAction = UIAlertAction(title: MultiLanguague.cancel, style: .cancel) { (_) in
            completion(false)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = MultiLanguague.passcode
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

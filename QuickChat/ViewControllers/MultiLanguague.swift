import UIKit
import Foundation

enum Languague {
    case english
    case vietnamese
}

final class MultiLanguague {
    
    static var languague = 1
    
    private init() {
        MultiLanguague.languague = 1
    }
    
    //MARK: Login view resource
    static var loginStr = "Login"
    static var emailStr =  "Email"
    static var passwordStr = "Password"
    static var errLoginStr = "Wrong input params, please try again"
    static var signInBtnStr = "Sign In"
    static var createAccBtnStr =  "Create new account"
    
    //MARK: message
    static var messageItem =  "Messages"
    
    //MARK: Contact
    static var contactItem  =  "Contacts"
    
    //MARK: Profile
    static var profileBtnLogout  =  "Log Out"
    static var profileItem  = "Profile"
    
    //MARK: Setting
    static var settingNotification = "Notification"
    static var settingTouchIDPasscode = "Touch ID & Passcode"
    static var settingLanguague =  "Language: English"
    static var settingRestoreDefaul =  "Restore Default Setting"
    static var settingTitle =  "Setting"
    
    static var success  =  "Success"
    static var error =  "Error"
    static var pleaseRestart =  "Please restart app to apply effect"
    static var passDoesNotMatch =  "Passcode does not match"
    static var tryAgain =  "Have error, please try again"
    static var wrongPassword =  "Wrong passcode"
    static var passcode =  "Passcode"
    static var inputPasscode =  "Please input passcode:"
    static var confirm =  "Confirm"
    static var cancel =  "Cancel"
    static var confirmPasscode =  "Confirm passcode"


    static func update(){
        //MARK: Login view resource
        loginStr = languague == 1 ? "Login" : "Đăng nhập"
        emailStr = languague == 1 ? "Email" : "Email"
        passwordStr = languague == 1 ? "Password" : "Mật khẩu"
        errLoginStr = languague == 1 ? "Wrong input params, please try again" : "Sai tên đăng nhập hoặc mật khẩu"
        signInBtnStr = languague == 1 ? "Sign In" : "Đăng nhập"
        createAccBtnStr = languague == 1 ? "Create new account" : "Tạo tài khoản mới"
        
        //MARK: message
        messageItem = languague == 1 ? "Messages" : "Tin nhắn"
        
        //MARK: Contact
        contactItem  = languague == 1 ? "Contacts" : "Danh bạ"
        
        //MARK: Profile
        profileBtnLogout  = languague == 1 ? "Log Out" : "Đăng xuất"
        profileItem  = languague == 1 ? "Profile" : "Hồ sơ"
        
        //MARK: Setting
        settingNotification = languague == 1 ? "Notification" : "Thông báo"
        settingTouchIDPasscode = languague == 1 ? "Touch ID & Passcode" : "Vân tay và mật khẩu"
        settingLanguague = languague == 1 ? "Language: English" : "Ngôn ngữ: Tiếng Việt"
        settingRestoreDefaul = languague == 1 ? "Restore Default Setting" : "Khôi phục cài đặt gốc"
        settingTitle = languague == 1 ? "Setting" : "Cài đặt"
  
        
        success = languague == 1 ? "Success" : "Thành công"
        error = languague == 1 ? "Error" : "Lỗi"
        pleaseRestart = languague == 1 ? "Please restart app to apply effect" : "Khởi động lại ứng dụng để cập nhật thay đổi"
        passDoesNotMatch = languague == 1 ? "Passcode does not match" : "Mật khẩu không trùng khớp"
        tryAgain = languague == 1 ? "Have error, please try again" : "Có lỗi xảy ra, vui lòng thử lại"
        wrongPassword = languague == 1 ? "Wrong passcode" : "Sai mật khẩu"
        passcode = languague == 1 ? "Passcode" : "Mật khẩu"
        inputPasscode = languague == 1 ? "Please input passcode:" : "Vui lòng nhập mật khẩu:"
        confirm = languague == 1 ? "Confirm" : "Xác nhận"
        cancel = languague == 1 ? "Cancel" : "Huỷ"
        confirmPasscode = languague == 1 ? "Confirm passcode" : "Nhập lại mật khẩu:"
        
    }
    
    //var  = Instance.languague == 1 ? "" : ""
}

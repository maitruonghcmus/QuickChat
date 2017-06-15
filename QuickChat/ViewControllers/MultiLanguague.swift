//
//  MultiLanguague.swift
//  QuickChat
//
//  Created by Truong Mai on 6/15/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

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
    
    
    
    static func update(){
        //MARK: Login view resource
        loginStr = languague == 1 ? "Login" : "Đăng nhập"
        emailStr = languague == 1 ? "Email" : "Email"
        passwordStr = languague == 1 ? "Password" : "Mật khẩu"
        errLoginStr = languague == 1 ? "Wrong input params, please try again" : "Sai tên đăng nhập hoặc mật khẩu"
        signInBtnStr = languague == 1 ? "Sign In" : "Đăng nhập"
        createAccBtnStr = languague == 1 ? "Create new account" : "Tạo tài khoản mới"
        
        //MARK: message
        messageItem = languague == 1 ? "Messages" : "Tin nhan"
        
        //MARK: Contact
        contactItem  = languague == 1 ? "Contacts" : "Danh ba"
        
        //MARK: Profile
        profileBtnLogout  = languague == 1 ? "Log Out" : "Dang Xuat"
        profileItem  = languague == 1 ? "Profile" : "Ho so"
        
        //MARK: Setting
        settingNotification = languague == 1 ? "Notification" : "Thong bao"
        settingTouchIDPasscode = languague == 1 ? "Touch ID & Passcode" : "Van tay va mat khau"
        settingLanguague = languague == 1 ? "Language: English" : "Ngon ngu: Tieng Viet"
        settingRestoreDefaul = languague == 1 ? "Restore Default Setting" : "Khoi phuc cai dat goc"
        settingTitle = languague == 1 ? "Setting" : "Cai dat"
    }
    
    //var  = Instance.languague == 1 ? "" : ""
}

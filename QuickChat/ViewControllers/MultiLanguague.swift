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

final class MultiLanguague : NSObject {
    
    static let Instance = MultiLanguague()
    
    var languague : Languague
    
    private override init() {
        languague = .vietnamese
    }
    
    //MARK: Login view resource
    var loginStr = Instance.languague == .english ? "Login" : "Đăng nhập"
    var emailStr = Instance.languague == .english ? "Email" : "Email"
    var passwordStr = Instance.languague == .english ? "Password" : "Mật khẩu"
    var errLoginStr = Instance.languague == .english ? "Wrong input params, please try again" : "Sai tên đăng nhập hoặc mật khẩu"
    var signInBtnStr = Instance.languague == .english ? "Sign In" : "Đăng nhập"
    var createAccBtnStr = Instance.languague == .english ? "Create new account" : "Tạo tài khoản mới"
    
    //MARK: message
    var messageItem = Instance.languague == .english ? "Messages" : "Tin nhan"
    
    //MARK: Contact
    var contactItem  = Instance.languague == .english ? "Contacts" : "Danh ba"
    
    //MARK: Profile
    var profileBtnLogout  = Instance.languague == .english ? "Log Out" : "Dang Xuat"
    var profileItem  = Instance.languague == .english ? "Profile" : "Ho so"
    
    //MARK: Setting
    var settingNotification = Instance.languague == .english ? "Notification" : "Thong bao"
    var settingTouchIDPasscode = Instance.languague == .english ? "Touch ID & Passcode" : "Van tay va mat khau"
    var settingLanguague = Instance.languague == .english ? "Language: English" : "Ngon ngu: Tieng Viet"
    var settingRestoreDefaul = Instance.languague == .english ? "Restore Default Setting" : "Khoi phuc cai dat goc"
    
    //var  = Instance.languague == .english ? "" : ""
}

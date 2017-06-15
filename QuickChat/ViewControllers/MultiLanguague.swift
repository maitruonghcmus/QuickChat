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
    
    
    //var  = Instance.languague == .english ? "" : ""
}

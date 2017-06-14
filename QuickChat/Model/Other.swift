//
//  Other.swift
//  QuickChat
//
//  Created by An Le on 6/14/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Other: NSObject {
    
    //MARK: Variable
    static var useTouchID : Bool = false
    static var useNotification : Bool = false
    static var passcode: String = ""
    
    class func get(completion: @escaping (Bool) -> Swift.Void) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("others").observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    Other.useTouchID = data["usetouchid"] != nil && data["usetouchid"] != "0" ? true : false
                    Other.useNotification = data["usenotification"] != nil && data["usenotification"] != "0" ? true : false
                    Other.passcode = data["passcode"] != nil ? data["passcode"]! : ""
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    class func update(completion: @escaping (Bool) -> Swift.Void) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let values = ["usetouchid": Other.useTouchID ? "1" : "0", "passcode": Other.passcode,"usenotification": Other.useNotification ? "1" : "0"]
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("others").updateChildValues(values, withCompletionBlock: { (errr, _) in
                if errr == nil {
                    completion(true)
                }
                else {
                    completion(false)
                }
            })
        }
        else {
            completion(false)
        }
    }
}

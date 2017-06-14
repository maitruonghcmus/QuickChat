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
    let usePasscode: Bool
    let passcode: String
    
    //MARK: init
    init(usePasscode:Bool,passcode: String) {
        self.usePasscode = usePasscode
        self.passcode = passcode
    }
    
    //MARK: Methods
    class func get(completion: @escaping (Other) -> Swift.Void) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("others").observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    let usePasscode = data["usePasscode"] as? Bool
                    let passcode = data["passcode"]!
                    let other = Other.init(usePasscode: usePasscode!, passcode: passcode)
                    completion(other)
                }
                else {
                    completion(Other(usePasscode: false, passcode: ""))
                }
            })
        }
        else {
            completion(Other(usePasscode: false, passcode: ""))
        }
        
    }
    
    class func update(other: Other, completion: @escaping (Bool) -> Swift.Void) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let values = ["usePasscode": other.usePasscode ? "1" : "0", "passcode": other.passcode]
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

//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit
import Firebase

class Conversation {
    
    //MARK: Properties
    let user: User
    var lastMessage: Message
    var locked : Bool
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
            var conversations = [Conversation]()
            FIRDatabase.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    let locked = values["locked"] != nil && values["locked"] == "1" ? true : false
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage, locked: locked)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                            completion(conversations)
                        })
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(user: User, lastMessage: Message, locked: Bool) {
        self.user = user
        self.lastMessage = lastMessage
        self.locked = locked
    }
    
    
    
    class func checkLocked(uid: String, completion: @escaping (Bool) -> Swift.Void) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("conversations").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    let locked = data["locked"] != nil && data["locked"] == "1" ? true : false
                    completion(locked)
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

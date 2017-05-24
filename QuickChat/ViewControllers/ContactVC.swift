//
//  ContactVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/24/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class ContactVC: UITableViewController {
    
    //MARK: *** Variable
    //MARK: *** UI Elements
    //MARK: *** Custom Functions
    //MARK: *** UI Events
    //MARK: *** View
    //MARK: *** Table View
    
    
    var items = [User]()
    var selectedUser: User?
    
    //Downloads users list for Contacts View
    func fetchUsers()  {
        if let id = FIRAuth.auth()?.currentUser?.uid {
            User.downloadAllUsers(exceptID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
        
        cell.profilePic.image = self.items[indexPath.row].profilePic
        cell.nameLabel.text = self.items[indexPath.row].name
        cell.profilePic.layer.borderWidth = 2
        cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row]
            self.performSegue(withIdentifier: "ContactToChatSegueID", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactToChatSegueID" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
}

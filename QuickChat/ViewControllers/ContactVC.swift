//
//  ContactVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/24/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class ContactVC: UITableViewController, UISearchBarDelegate {
    
    //MARK: *** Variable
    var items = [User]()
    var selectedUser: User?
    var filtered:[User] = []
    var searchActive : Bool = false
    
    //MARK: *** UI Elements
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    func setLanguague(){
        DispatchQueue.main.async {
            self.navigationItem.title = MultiLanguague.contactItem
        }
        
        //self.setLanguague(lang: MultiLanguague.languague)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setLanguague()
    }
    
    //MARK: *** Custom Functions
    //Downloads users list for Contacts View
    func fetchUsers()  {
        if let id = FIRAuth.auth()?.currentUser?.uid {
            User.downloadAllUsers(exceptID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.filtered.append(user)
                    self.tableView.reloadData()
                }
            })
            
        }
    }
    
    //MARK: *** UI Events
    
    
    //MARK: *** View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsers()
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactToChatSegueID" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    //MARK: *** Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
        
        if self.filtered.count > 0 {
            
            let currentItem = filtered[indexPath.row]
            
            cell.profilePic.image = currentItem.profilePic
            cell.nameLabel.text = currentItem.name
            cell.profilePic.layer.borderWidth = 2
            cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filtered.count > 0 {
            self.selectedUser = filtered[indexPath.row]
            Conversation.checkLocked(uid: (self.selectedUser?.id)!, completion: {(locked) in
                if Other.useTouchID == true && locked == true {
                    self.showAlert(completion: { (ok) in
                        if ok == true {
                            self.performSegue(withIdentifier: "ContactToChatSegueID", sender: self)
                        }
                        else {
                            self.showAlertFail()
                        }
                    })
                }
                else {
                    self.performSegue(withIdentifier: "ContactToChatSegueID", sender: self)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.filtered.count > 0 && Other.useTouchID == true {
            self.selectedUser = filtered[indexPath.row]
            let unlock = UITableViewRowAction(style: .normal, title: "Unlock") { action, index in
                self.showAlert(completion: {(ok) in
                    if ok == true {
                        Conversation.setLocked(uid: (self.selectedUser?.id)!, locked: false, completion: { (ok) in
                            if ok == true {
                                self.showAlert(title: "Sucess", message: "Unlock success")
                            } else {
                                self.showAlert(title: "Fail", message: "Unlock fail. Try again")
                            }
                        })
                    } else {
                        self.showAlertFail()
                    }
                })
            }
            let lock = UITableViewRowAction(style: .destructive, title: "Lock") { action, index in
                Conversation.setLocked(uid: (self.selectedUser?.id)!, locked: true, completion: { (ok) in
                    if ok == true {
                        self.showAlert(title: "Sucess", message: "Lock success")
                    } else {
                        self.showAlert(title: "Fail", message: "Lock fail. Try again")
                    }
                })
            }
            return [unlock, lock]
        }
        return []
    }
    
    //MARK: *** Search Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            filtered = items.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            searchActive = true
        }
        else {
            filtered = items
            searchActive = false
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: show lock alert
    func showAlert(completion: @escaping (Bool) -> Swift.Void){
        let alertController = UIAlertController(title: "Passcode", message: "Please input passcode:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text == Other.passcode {
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
    
    func showAlertFail() {
        let alertVC = UIAlertController(title: "Passcode", message: "Wrong passcode", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

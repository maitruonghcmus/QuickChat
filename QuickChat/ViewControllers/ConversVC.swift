//
//  ConversVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/24/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox
import UserNotifications

class ConversVC: UITableViewController, UISearchBarDelegate, UNUserNotificationCenterDelegate {
    
    //MARK: *** Variable
    var items = [Conversation]()
    var selectedUser: User?
    var filtered:[Conversation] = []
    var searchActive : Bool = false
    // permission push notification
    var allowPush : Bool = false
    let requestIdentifier = "PushRequest"
    let requestImageIdentifier = "PushImageRequest"
    
    //MARK: *** UI Elements
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: *** Custom Functions
    //Download all conversation
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            self.filtered = self.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.playSound()
                        
                    }
                    if self.allowPush == true && conversation.lastMessage.isRead == false && conversation.lastMessage.owner == .sender {
                        self.pushNotification(conv: conversation)
                    }
                }
            }
        }
    }
    
    //Shows Chat viewcontroller with given user
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    //Play sound when give a new message
    func playSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    func showEditing() {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    //MARK: *** push notification
    func pushNotification(conv: Conversation) {
        self.selectedUser = conv.user
        let content = UNMutableNotificationContent()
        content.title = "New message"
        content.subtitle = "From \(conv.user.name)"
        switch conv.lastMessage.type {
        case .text:
            let message = conv.lastMessage.content as! String
            content.body = message
        case .location:
            content.body = "Location"
        default:
            content.body = "Add new image"
            //To Present image in notification
                let url = URL.init(string: conv.lastMessage.content as! String)
                
                do {
                    let attachment = try UNNotificationAttachment(identifier: requestImageIdentifier, url: url!, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("attachment not found.")
                }
        }
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.performSegue(withIdentifier: "NewSegue", sender: self)
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            completionHandler( [.alert,.sound,.badge])
        }
    }
    
    //MARK: *** UI Events
    
    
    //MARK: *** View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        searchBar.delegate = self
        //        let leftBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("showEditing:")))
        //        self.navigationItem.leftBarButtonItem = leftBarButton
        // add permission push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            didAllow,error in
            self.allowPush = didAllow
        })
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if allowPush == true {
        }
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewSegue" {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversCell", for: indexPath) as! ConversCell
        
        if self.filtered.count > 0{
            
            let currentItem = filtered[indexPath.row]
            
            cell.clearCellData()
            cell.profilePic.image = currentItem.user.profilePic
            cell.nameLabel.text = currentItem.user.name
            
            switch currentItem.lastMessage.type {
            case .text:
                let message = currentItem.lastMessage.content as! String
                cell.messageLabel.text = message
            case .location:
                cell.messageLabel.text = "Location"
            default:
                cell.messageLabel.text = "Media"
            }
            
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(currentItem.lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            
            if currentItem.lastMessage.owner == .sender && currentItem.lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
                cell.messageLabel.textColor = GlobalVariables.blue
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filtered.count > 0 {
            self.selectedUser = self.filtered[indexPath.row].user
            self.performSegue(withIdentifier: "NewSegue", sender: self)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
                $0.user.name.lowercased().contains(searchText.lowercased())
            }
            searchActive = true
        }
        else {
            filtered = items
            searchActive = false
        }
        
        self.tableView.reloadData()
    }
}

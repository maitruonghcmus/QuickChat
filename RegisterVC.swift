//
//  RegisterVC.swift
//  QuickChat
//
//  Created by Truong Mai on 5/23/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Photos

class RegisterVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK - Variables
    
    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblMessage: UILabel!

    let imagePicker = UIImagePickerController()
    
    //MARK - Custom function
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
        self.show(vc, sender: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgProfile.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK - Events
    
    @IBAction func btnBackToSignIn_Tapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectPicture_Tapped(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func btnRegister_Tapped(_ sender: Any) {
        User.registerUser(withName: self.txtName.text!, email: self.txtEmail.text!, password: self.txtPassword.text!, profilePic: self.imgProfile.image!) { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                
                if status == true {
                    weakSelf?.pushTomainView()
                    //weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
                } else {
//                    for item in (weakSelf?.waringLabels)! {
//                        item.isHidden = false
//                    }
                    self.lblMessage.isHidden = false
                }
            }
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

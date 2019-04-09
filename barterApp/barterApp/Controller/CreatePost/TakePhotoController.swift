//
//  TakePhotoController.swift
//  barterApp
//
//  Created by William Cho on 2019-03-08.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import Photos

class TakePhotoController: UIViewController  {
    
    var ref: DatabaseReference!
    
    var storageRef: StorageReference!
    
    var currentVC: UIViewController!
    
    var flag = true
    

    
    //Outlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    
    func showAlert(){
        if(flag){
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.camera()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.photoLibrary()
            }))
            
            //actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.tabBarController?.selectedIndex = 0
            }))
            
            self.present(actionSheet, animated: true, completion: nil)
            flag = false
        }
    }
    
    @IBAction func post(_ sender: Any) {
        if (!titleOutlet.text!.isEmpty && !descriptionOutlet.text!.isEmpty){
            print("Posting Data")
            ref = Database.database().reference()
            let userId = BACurrentUser.currentUser.uid
            let itemTitle = titleOutlet.text
            let itemDescription = descriptionOutlet.text
            let dateTime = ServerValue.timestamp()
            uploadMedia() { url in
                guard let url = url else { return }
                self.ref.child("barters").childByAutoId().setValue([
                    "userID"    : userId!,
                    "title"     : itemTitle!,
                    "descr"     : itemDescription!,
                    "dateTime"  : dateTime,
                    "photoUrl"  : url,
                    ])
                }
            self.tabBarController?.selectedIndex = 0
        }
    }
    

    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        let uuid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("itemPhotos/\(uuid)")
        if let uploadData = photo.image!.jpegData(compressionQuality: 0.75) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL { url, error in
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
 
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
}



extension TakePhotoController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        self.titleOutlet.delegate = self
        self.descriptionOutlet.delegate = self
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photo.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
      
        if titleOutlet.isFirstResponder{
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        
        if descriptionOutlet.isFirstResponder{
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y=0
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
<<<<<<< HEAD
   
  
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
||||||| merged common ancestors
    func unsubscribeFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self)
        
        

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
=======
    func unsubscribeFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self)
        
        

    }
    
>>>>>>> dd4fe0c1afdb9d5a135550c933f135141a084126
    
}

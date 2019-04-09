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
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(actionSheet, animated: true, completion: nil)
            flag = false
            
        }
        
    }
    
    //Outlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    @IBAction func post(_ sender: Any) {
        
        
        if (!titleOutlet.text!.isEmpty && !descriptionOutlet.text!.isEmpty){
            
            
            print("Posting Data")
            ref = Database.database().reference()
            let userId = BACurrentUser.currentUser.uid
            let itemTitle = titleOutlet.text
            let itemDescription = descriptionOutlet.text
            let dateTime = ServerValue.timestamp()
           // let photoUrl =  "hello"
           // self.ref.child("barters").childByAutoId().setValue(["userID": userId, "title": itemTitle, "descr" : itemDescription, "dateTime": dateTime,  "photoUrl" : photoUrl])
            
            
            
            
            uploadMedia() { url in
                guard let url = url else { return }
                self.ref.child("barters").childByAutoId().setValue([
                    "userID"    : userId!,
                    "title"      : itemTitle!,
                    "descr"    : itemDescription!,
                    "dateTime"     : dateTime,
                    "photoUrl"       : url,
                    ])
            }
        }
            dismiss(animated: true, completion: nil)
        }
    
//    func uploadMediaa() {
//
//        // let storageRef = Storage.storage().reference().child()
//
//        if let uploadData = self.photo.image!.pngData(){
//
//            storageRef.putData(uploadData, metadata: nil, completion:
//                { (metadata, error) in
//                if error != nil {
//                    print(error)
//                    return
//                }
//                print(metadata)
//            })
//
//        }
//    }
    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
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

//    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("user/\(uid)")
//
//        let imageData = photo.image!.jpegData(compressionQuality: 0.75)
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//
//        storageRef.putData(imageData!, metadata: metaData) { metaData, error in
//            if error == nil, metaData != nil {
//
//                storageRef.downloadURL { url, error in
//                    completion(url)
//                    // success!
//                }
//            } else {
//                // failed
//                completion(nil)
//            }
//        }
//    }
    

        
    
    
    
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
    
    override func viewDidLoad() {
        self.titleOutlet.delegate = self
        self.descriptionOutlet.delegate = self
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
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
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TakePhotoController.keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TakePhotoController.keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if titleOutlet.isFirstResponder{
            self.view.frame.origin.y = 0
        }
        if descriptionOutlet.isFirstResponder{
            self.view.frame.origin.y = 0
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
    
    func unsubscribeFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self)
        
        

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

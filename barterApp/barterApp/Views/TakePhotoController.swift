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
    var currentVC: UIViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TakePhotoController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    //Outlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    @IBAction func post(_ sender: Any) {
        if (!titleOutlet.text!.isEmpty && !descriptionOutlet.text!.isEmpty){
            
            
            print("Posting Data")
            ref = Database.database().reference()
            
            
            let userId = "testUserID"
            let itemTitle = titleOutlet.text
            let itemDescription = descriptionOutlet.text
            let dateTime = ""
            
            let photoURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(photo!.debugDescription);
            
            
            
            
            self.ref.child("barters").childByAutoId().setValue(["userID": userId, "title": itemTitle, "descr" : itemDescription, "dateTime": dateTime,  "photoUrl" : photoURL])
            
           
        
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


extension TakePhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
    
}


extension TakePhotoController: UITextFieldDelegate {
    
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

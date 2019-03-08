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

class TakePhotoController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var photo: UIImageView!
    
    
    
    
    
    
    
    
    @IBAction func takePhoto(_ sender: Any) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photo.image = info[.originalImage] as? UIImage
    }
}

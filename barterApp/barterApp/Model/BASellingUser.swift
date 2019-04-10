//
//  BASellingUser.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/10/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase

class BASellingUser {
    
    var uid: String?
    var ref: DatabaseReference?
    var email: String?
    var fName: String?
    var lName: String?
    var photoURL: String?
    
    // Initialize from Firebase
    init(snapshot: DataSnapshot) {
        
        self.uid = snapshot.key
        self.ref = snapshot.ref
        self.email = (snapshot.value! as AnyObject).object(forKey: "email") as? String
        self.fName = (snapshot.value! as AnyObject).object(forKey: "fName") as? String
        self.lName = (snapshot.value! as AnyObject).object(forKey: "lName") as? String
        self.photoURL = ((snapshot.value! as AnyObject).object(forKey: "photoURL") as? String)!
    }
}

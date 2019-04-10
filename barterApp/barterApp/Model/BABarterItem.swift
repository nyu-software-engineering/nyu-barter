//
//  BABarterItem.swift
//  barterApp
//
//  Created by Kevin Maldjian on 3/6/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase

class BABarterItem {
    
    let uid: String
    var ref: DatabaseReference
    var title: String
    var descr: String
    var dateTime: Int
    var photoUrl: String
    var userId: String
    
    // Initialize from Firebase
    init(snapshot: DataSnapshot) {
        
        self.uid = snapshot.key
        self.ref = snapshot.ref
        self.title = (snapshot.value! as AnyObject).object(forKey: "title") as! String
        self.descr = (snapshot.value! as AnyObject).object(forKey: "descr") as! String
        self.dateTime = (snapshot.value! as AnyObject).object(forKey: "dateTime") as! Int
        self.photoUrl = ((snapshot.value! as AnyObject).object(forKey: "photoUrl") as? String)!
        self.userId = ((snapshot.value! as AnyObject).object(forKey: "userID") as? String)!
    }
}


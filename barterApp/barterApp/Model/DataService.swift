//
//  DataService.swift
//  barterApp
//
//  Created by Kevin Maldjian on 3/5/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase

class DataService {
    
    static let sharedInstance = DataService()
    
    private var _USER_REF                       = Database.database().reference().child("users")
    private var _FEED_REF                       = Database.database().reference().child("barters")
    private var _STORAGE_REF                    = Storage.storage().reference()
    private var _SELLER_REF                     = Database.database().reference().child("users") 
    
    var USER_REF: DatabaseReference {
        return _USER_REF
    }
    
    var FEED_REF: DatabaseReference {
        return _FEED_REF
    }
    
    var STORAGE_REF: StorageReference {
        return _STORAGE_REF
    }
    
    var SELLER_REF: DatabaseReference {
        return _SELLER_REF
    }

}

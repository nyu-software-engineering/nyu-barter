//
//  BACurrentUser.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/8/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase


class BACurrentUser {
    
    static let currentUser = BACurrentUser()

    var uid: String?
    var ref: DatabaseReference?
    var email: String?
    var fName: String?
    var lName: String?
    var photoURL: String?
    var phoneNumber: String?
    
    init () {
        
        
    }
}


//
//  CreateViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 3/5/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createTestData(_ sender: Any) {
        print("Submitting Test Data!")
        ref = Database.database().reference()
        let userId = "testUserID"
        let itemTitle = "Iphone 6s"
        let itemDescription = "Looking to trade for a toaster"
        let dateTime = ServerValue.timestamp()
        let photoURL = ""
        self.ref.child("barters").childByAutoId().setValue(["userID": userId, "title": itemTitle, "descr" : itemDescription, "dateTime": dateTime,  "photoUrl" : photoURL])
    }
    
    
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

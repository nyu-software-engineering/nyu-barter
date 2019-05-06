//
//  SettingsViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 5/6/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import GoogleSignIn


class SettingsViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.21, green:0.64, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Settings"
        setPhoto()
        setInfo()

        // Do any additional setup after loading the view.
    }

    @IBAction func leaveSettings(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPhoto(){
        if let usersPhoto = BACurrentUser.currentUser.photoURL {
            let url = URL(string: usersPhoto)
            userImage.kf.setImage(with: url)
        }
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }
    
    func setInfo(){
        let userName = BACurrentUser.currentUser.fName
        lblName.text = userName
        let userEmail = BACurrentUser.currentUser.email
        lblEmail.text = userEmail
    }

    
    @IBAction func logOut(_ sender: Any) {
        print("Bye")
        do {
            try Auth.auth().signOut()
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                GIDSignIn.sharedInstance().signOut()
                print("Signing out Google User")
            }
        } catch let logoutError {
            print(logoutError)
        }
        goFirstScreen()
    }
    
    func goFirstScreen() {
        self.dismiss(animated: false, completion: nil)
        let LoginUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = LoginUpViewController
    }
    
}

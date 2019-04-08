//
//  ListingsViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/8/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ListingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func goFirstScreen() {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainPage = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.present(mainPage, animated: true, completion: nil)
        InterfaceManager.sharedInstance.mainTabViewCon = nil
        BACurrentUser.currentUser.uid = nil
    }
}

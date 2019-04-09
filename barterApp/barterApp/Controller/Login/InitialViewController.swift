//
//  ViewController.swift
//  hairCut
//
//  Created by Kevin Maldjian on 1/10/18.
//  Copyright © 2018 Kevin Maldjian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class InitialViewController: UIViewController {
    
    var bLoadedView: Bool = false
    
    var viewCon: MenuViewController? = nil
    
    var bCheckedLoginStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (bLoadedView) {
            return
        }
        
        bLoadedView = true
        self.checkUserAuthentication()
    }
    
    func checkUserAuthentication() {
        //- Todo: Fill out elements of HCCurrent User
        Auth.auth().addStateDidChangeListener { auth, user in
            if (self.bCheckedLoginStatus) {
                return
            }
            
            self.bCheckedLoginStatus = true

            if let user = user {
                BACurrentUser.currentUser.uid = user.uid
                BACurrentUser.currentUser.fName = user.displayName
                BACurrentUser.currentUser.photoURL = user.photoURL?.absoluteString
//                TheMessageService.getUser(user.uid, { (user, error) in
//                    if (user != nil) {
//                        HCCurrentUser.currentUser.fName = user!.fName
//                        HCCurrentUser.currentUser.lName = user!.lName
//                    }
//                })
                self.goMainScreen()
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.goFirstScreen()
                })
            } else {
                self.goFirstScreen()
            }
        }
    }
    
    func goFirstScreen() {
        if (viewCon != nil) {
            viewCon?.willMove(toParent: nil)
            viewCon?.view.removeFromSuperview()
            viewCon?.removeFromParent()
            viewCon = nil
        }
        
        viewCon = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        self.addChild(viewCon!)
        self.view.addSubview(viewCon!.view)
        viewCon!.didMove(toParent: self)
    }
    
    func goMainScreen() {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let mainPage = storyboard.instantiateViewController(withIdentifier: "MainTab")
        self.present(mainPage, animated: true, completion: nil)
    }
}


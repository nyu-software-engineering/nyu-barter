//
//  StoryboardExampleViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 8/8/18.
//  Copyright © 2018 Kevin Maldjian. All rights reserved.
//

import UIKit
import SwiftyOnboard
import CoreLocation
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class MenuViewController: UIViewController, GIDSignInUIDelegate{
    
    var activityView: UIActivityIndicatorView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
    }
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func facebookLogin(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { result, err in
            if let error = err {
                print("Custom FB Login failed:", error.localizedDescription)
            } else {
                if (result?.token == nil) {
                    print("Custom FB Login canceled")
                } else {
                    // No error
                    self.activityView.center = CGPoint(x: self.facebookButton.bounds.width / 2.0, y: self.facebookButton.bounds.height / 2.0)
                    self.activityView.isHidden = false
                    self.activityView.startAnimating()
                    
                    self.showEmailAddress()
                }
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().signIn()
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.backgroundColor = appColors.backgroundColor()
        activityView = UIActivityIndicatorView(style: .white)
        activityView.color = UIColor(red:0.19, green:0.69, blue:0.73, alpha:1.0)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        self.facebookButton.addSubview(activityView)
        activityView.isHidden = true
        activityView.stopAnimating()
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
//        if (swiftyOnboard.currentPage == 2){
//            performSegue(withIdentifier: "getStarted", sender: nil)
//        }
    }
}

extension MenuViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "boarding\(index).png")
        if index == 0 {
            //On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "Rush"
            view?.subTitleLabel.text = "List items you wish \n to trade"
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "Rush"
            view?.subTitleLabel.text = "View barters from \n other students"

        } else{
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "Rush"
            view?.subTitleLabel.text = "Get New Stuff!"
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.contentControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.buttonContinue.setTitle("Continue", for: .normal)
            overlay.skip.setTitle("Skip", for: .normal)
            overlay.skip.isHidden = false
        } else {
            overlay.buttonContinue.setTitle("Sign In Below", for: .normal)
            overlay.skip.isHidden = true
        }
    }
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: { user, error in
            self.activityView.stopAnimating()
            self.activityView.isHidden = true
            
            if let error = error {
                print("Something went wrong with our FB user: ", error.localizedDescription)
            } else {
                print("Successfully logged in with our user: ", user ?? "")
                // Update fields on Firebase backend
                if let user = user {
                    // User found
                    BACurrentUser.currentUser.uid = user.uid
                    var userValues: [String: Any] = [:]
                    if let usersName = user.displayName {
                        let fullNameArr = usersName.components(separatedBy: " ")
                        let name    = fullNameArr[0]
                        let surname = fullNameArr[1]
                        BACurrentUser.currentUser.fName = name
                        BACurrentUser.currentUser.lName = surname
                        userValues["fName"] = name
                        userValues["lName"] = surname
                    }
                    if let usersPhoto = user.photoURL {
                        BACurrentUser.currentUser.photoURL = usersPhoto.absoluteString
                        userValues["photoURL"] = usersPhoto.absoluteString
                    }
                    if let usersEmail = user.email {
                        BACurrentUser.currentUser.email = usersEmail
                        userValues["email"] = usersEmail
                    }
                    
                    // Update the users values (or create them if this is the first login)
                    DataService.sharedInstance.USER_REF.child(user.uid).updateChildValues(userValues, withCompletionBlock: { err, ref in
                        if let error = err {
                            print(error.localizedDescription)
                        } else {
//                            let viewCon = self.storyboard?.instantiateViewController(withIdentifier: Constants.ViewID.HomeViewController)
//                            self.navigationController?.pushViewController(viewCon!, animated: true)
                            //check if user verified phone nubmer
                            //let userID = Auth.auth().currentUser?.uid
                           // let hasVerified = checkVerifiedPhone.checkVerify(userID: userID!)
                            if true{
                                //user has a verified phone
                                let storyboard = UIStoryboard(name: "Tab", bundle: nil)
                                let mainPage = storyboard.instantiateViewController(withIdentifier: "MainTab")
                                self.present(mainPage, animated: true, completion: nil)                            }
                            else{
                                //user must verify phone
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainPage = storyboard.instantiateViewController(withIdentifier: "StartVerificationViewController")
                                self.present(mainPage, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
        })
    }
}

//
//  AppDelegate.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/24/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions : launchOptions)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return googleDidHandle || facebookDidHandle
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            // User is signed in
            // ...
            if let user = user {
                // User found
                BACurrentUser.currentUser.uid = Auth.auth().currentUser?.uid
                var userValues: [String: Any] = [:]
                if let usersName = user.profile.givenName {
                    BACurrentUser.currentUser.fName = usersName
                    BACurrentUser.currentUser.lName = user.profile.familyName
                    userValues["fName"] = user.profile.givenName
                    userValues["lName"] = user.profile.familyName
                }
                if let usersPhoto = user.profile.imageURL(withDimension: 250) {
                    BACurrentUser.currentUser.photoURL = usersPhoto.absoluteString
                    userValues["photoURL"] = usersPhoto.absoluteString
                }
                if let usersEmail = user.profile.email {
                    BACurrentUser.currentUser.email = usersEmail
                    userValues["email"] = usersEmail
                }
                
                // Update the users values (or create them if this is the first login)
                DataService.sharedInstance.USER_REF.child(BACurrentUser.currentUser.uid!).updateChildValues(userValues, withCompletionBlock: { err, ref in
                    if let error = err {
                        print(error.localizedDescription)
                    } else {
                        
                        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
                        let mainPage = storyboard.instantiateViewController(withIdentifier: "MainTab")
                        self.window?.rootViewController = mainPage
                        
                        
                        
                        // Here is the logic for checking a verified phone, we wont use that in this sprint
                        
                        
                        
//                        self.phoneCheck = Database.database().reference()
//                        self.phoneCheck.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            // Get user value
//                            if snapshot.hasChild("phoneNumber"){
//                                print("fonud")
//                                let storyboard = UIStoryboard(name: "Tab", bundle: nil)
//                                let mainPage = storyboard.instantiateViewController(withIdentifier: "MainTab")
//                                self.window?.rootViewController = mainPage
//                            }else{
//                                print("We did it!")
//                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainPage = storyboard.instantiateViewController(withIdentifier: "StartVerificationViewController")
//                                self.window?.rootViewController = mainPage
//                            }
                        
                            // ...
//                        }) { (error) in
//                            print(error.localizedDescription)
//                        }
                        
                    }
                })
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "barterApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


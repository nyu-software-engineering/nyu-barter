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

struct Cell{
    let image: UIImage?
    let title: String?
}

class ListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var postData = [String]()
    var data = [Cell]()
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let index = postData.count - indexPath.row - 1
        cell.textLabel?.text = postData[index]
        return cell
        
    }
    
    @IBOutlet weak var favoritesOutlet: UIButton!
    @IBOutlet weak var tradingOutlet: UIButton!
    @IBOutlet weak var tradedOutlet: UIButton!
    
    
    @IBAction func favoritesButton(_ sender: Any) {
        enableAllButtons()
        favoritesOutlet.isEnabled = false
    }
    
    @IBAction func tradingButton(_ sender: Any) {
        enableAllButtons()
        tradingOutlet.isEnabled = false
    }
    
    @IBAction func tradedButton(_ sender: Any) {
        enableAllButtons()
        tradedOutlet.isEnabled = false
    }
    
    func enableAllButtons(){
        favoritesOutlet.isEnabled = true
        tradingOutlet.isEnabled = true
        tradedOutlet.isEnabled = true
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("barters").observe(.childAdded, with: { (DataSnapshot) in
            let post = DataSnapshot.value as? String
            
            if let actualPost = post {
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
        
        
        favoritesButton(self)
        
        
        
        

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

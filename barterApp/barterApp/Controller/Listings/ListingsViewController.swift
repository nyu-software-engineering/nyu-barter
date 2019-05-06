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




class ListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    
    var barterItems: [BABarterItem] = []
    var serviceObserver: UInt?
    
    //to pass
    var barter : BABarterItem!
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        //initially on items to trade
        //tradingButton(self)
        tableView.estimatedRowHeight = 100
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadFromFirebase()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        let index = barterItems.count - indexPath.row - 1
        barter = barterItems[index]
        image = cell.imageView?.image
        performSegue(withIdentifier: "infoView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoView"
        {
            let destViewController = segue.destination as! UINavigationController
            let infoVC = destViewController.viewControllers.first as! ItemInfoViewController
            infoVC.barterItem = barter
            
            //nil handling
            if(image == nil){
                infoVC.passPhoto = UIImage.init(named: "listings")!
            }
            else{
                infoVC.passPhoto = image
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barterItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListingsCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ListingsCell
        let index = barterItems.count - indexPath.row - 1
        //cell.textLabel?.text = barterItems[index].title
        cell.title?.text = barterItems[index].title
        //cell.detailTextLabel?.text = barterItems[index].descr
        cell.descr?.text = barterItems[index].descr
        
        let image = UIImage(named: "BlankProfilePicture")
        let photoUrl = URL(string: barterItems[index].photoUrl)
        //cell.imageView?.kf.setImage(with: photoUrl, placeholder: image)
        cell.imagee?.kf.setImage(with: photoUrl, placeholder: image)
        
        
       // let storageRef = Storage.storage().reference(forURL: photoUrl)
        
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//            // Create a UIImage, add it to the array
//            if(data == nil){
//                cell.imageView?.image = UIImage.init(named: "default")
//            }
//            else{
//                let pic = UIImage(data: data!)
//                cell.imageView?.image = pic
//            }
//        }
        
        
        
        return cell
        
    }
    
//    @IBOutlet weak var favoritesOutlet: UIButton!
//    @IBOutlet weak var tradingOutlet: UIButton!
//    @IBOutlet weak var tradedOutlet: UIButton!
//    
//    
//    @IBAction func favoritesButton(_ sender: Any) {
//        enableAllButtons()
//        favoritesOutlet.isEnabled = false
//    }
//    
//    @IBAction func tradingButton(_ sender: Any) {
//        enableAllButtons()
//        tradingOutlet.isEnabled = false
//    }
//    
//    @IBAction func tradedButton(_ sender: Any) {
//        enableAllButtons()
//        tradedOutlet.isEnabled = false
//    }
//    
//    func enableAllButtons(){
//        favoritesOutlet.isEnabled = true
//        tradingOutlet.isEnabled = true
//        tradedOutlet.isEnabled = true
//    }
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    func loadFromFirebase(){
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref?.child("barters").queryOrdered(byChild: "userID").queryEqual(toValue: userID!).observe(.childAdded, with: { (snapshot) in
            let item = BABarterItem(snapshot: snapshot )
            self.barterItems.append(item)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
    }
    
    //class function Singleton
    
    class func sharedInstance() -> ListingsViewController {
        struct Singleton {
            static var sharedInstance = ListingsViewController()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
    
    
    
    
    
    //-------

    

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

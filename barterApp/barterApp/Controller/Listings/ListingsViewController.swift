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
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
        tableView.separatorStyle = .none
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let index = barterItems.count - indexPath.row - 1
        cell.textLabel?.text = barterItems[index].title
        cell.detailTextLabel?.text = barterItems[index].descr
        cell.selectionStyle = .none
        let image = UIImage(named: "BlankProfilePicture")
        let photoUrl = URL(string: barterItems[index].photoUrl)
        cell.imageView?.kf.setImage(with: photoUrl, placeholder: image)

        return cell
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    func loadFromFirebase(){
        self.barterItems  = []
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
    
    func fetchFavorites(){
        self.barterItems  = []
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref?.child("users").child(userID!).child("faves").observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if(rest.value as! Bool){
                    self.getPost(postID: rest.key)
                }
            }
        }


    }
    

    @IBAction func switchTable(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if (index == 0){
            loadFromFirebase()
        }else{
            fetchFavorites()
        }
    }
    
    func getPost(postID: String){
        ref = Database.database().reference()
        ref?.child("barters").child(postID).observeSingleEvent(of: .value) { snapshot in
            let item = BABarterItem(snapshot: snapshot )
            self.barterItems.append(item)
            print(item.title)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("we are back")
        if (segmentedControl.selectedSegmentIndex == 0){
            loadFromFirebase()
        }else{
            fetchFavorites()
        }
    }
    
    
    

}

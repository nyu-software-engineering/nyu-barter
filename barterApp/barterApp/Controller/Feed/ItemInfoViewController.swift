//
//  ItemInfoViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/9/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Hero
import Firebase
import Kingfisher

class ItemInfoViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var itemPhoto: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var btnContact : UIButton!
    
    var barterItem : BABarterItem!
    var seller : BASellingUser!
    var passPhoto = UIImage()
    var serviceObserver: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.hero.isEnabled = true
        setUp.setUpPicNav(navCon: self.navigationController!)
        itemPhoto.image = passPhoto
        lblTitle.text = barterItem.title
        lblDescription.text = barterItem.descr
        
        posterImage.layer.borderWidth = 1
        posterImage.layer.masksToBounds = false
        posterImage.layer.borderColor = UIColor.white.cgColor
        posterImage.layer.cornerRadius = posterImage.frame.height/2
        posterImage.clipsToBounds = true
        
       // btnContact.backgroundColor = .clear
        btnContact.layer.cornerRadius = btnContact.bounds.size.height/2
        btnContact.clipsToBounds = true
        //btnContact.layer.borderColor = UIColor.black.cgColor
        
        print("were back")
        getPoster()
    }
    
    @IBAction func backToFeed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getPoster(){
        serviceObserver = DataService.sharedInstance.SELLER_REF.child(barterItem.userId).observe(.value, with: { snapshot in
            self.seller = BASellingUser(snapshot: snapshot)
           // let value = snapshot.value as? NSDictionary
            //let url = URL(string: value?["photoURL"] as? String ?? "")
            //self.posterImage.kf.setImage(with: url)
            do {
                try self.setInfo(snapshot: snapshot)
                print("Success! Photo is set.")
            } catch SellerError.invalidPhotoURL {
                print("Invalid Selection.")
            } catch SellerError.invalidInternetConnection {
                print("No internet connection.")
            } catch SellerError.invalidPrivldeges{
                print("This account does not have privldeges to read from Firebase.")
            } catch {
                print("Unexpected error: \(error).")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func setInfo(snapshot: DataSnapshot) throws{
        guard let value = snapshot.value as? NSDictionary else{
            throw SellerError.invalidPrivldeges
        }
        guard let url = URL(string: value["photoURL"] as? String ?? "") else{
            throw SellerError.invalidPhotoURL
        }
        self.posterImage.kf.setImage(with: url){ result in
            // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
            switch result {
            case .success(let value):
                // The image was set to image view:
                print(value.image)
                
                // From where the image was retrieved:
                // - .none - Just downloaded.
                // - .memory - Got from memory cache.
                // - .disk - Got from disk cache.
                print(value.cacheType)
                
                // The source object which contains information like `url`.
                print(value.source)
                
            case .failure(let error):
                print(error) // The error happens
            }
        }
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



enum SellerError: Error {
    case invalidPhotoURL
    case invalidInternetConnection
    case invalidPrivldeges
}

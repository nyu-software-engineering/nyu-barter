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
import SwiftEntryKit

class ItemInfoViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var itemPhoto: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var btnContact : UIButton!
    var ref: DatabaseReference!
    
    var barterItem : BABarterItem!
    var seller : BASellingUser!
    var passPhoto = UIImage()
    var serviceObserver: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        self.hero.isEnabled = true
        setUp.setUpPicNav(navCon: self.navigationController!)
        itemPhoto.image = passPhoto
        lblTitle.text = barterItem.title
        lblDescription.text = barterItem.descr
        
        posterImage.layer.borderWidth = 1
        posterImage.layer.masksToBounds = false
        posterImage.layer.borderColor = UIColor.white.cgColor
        posterImage.layer.cornerRadius = posterImage.bounds.size.height / 2
        posterImage.clipsToBounds = true
        
       // btnContact.backgroundColor = .clear
        btnContact.layer.cornerRadius = 10
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
            } catch SellerError.invalidPrivileges{
                print("This account does not have privileges to read from Firebase.")
            } catch {
                print("Unexpected error: \(error).")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func setInfo(snapshot: DataSnapshot) throws{
        guard let value = snapshot.value as? NSDictionary else{
            throw SellerError.invalidPrivileges
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

    
    @objc func doubleTapped() {
        ref = Database.database().reference().child("users")
        let dateTime = ServerValue.timestamp()
        if let user = BACurrentUser.currentUser.uid{
            ref.child(user).child("faves").updateChildValues([barterItem.uid : true])
            displayPopUp()
        }
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        let email = seller.email!
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        //print(seller.email)
    }
    
    func displayPopUp(){
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .gradient(gradient: .init(colors: [.white, .white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        //attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        let title = EKProperty.LabelContent(text: "Barter App", style: .init(font: (UIFont(name: "SF Pro Text", size: 20) ?? nil)!, color: .black))
        let description = EKProperty.LabelContent(text: "You have added this item to your favorites!", style: .init(font: (UIFont(name: "SF Pro Text", size: 15) ?? nil)!, color: .black))
        let image = EKProperty.ImageContent(image: UIImage(named: "give")!, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
}



enum SellerError: Error {
    case invalidPhotoURL
    case invalidInternetConnection
    case invalidPrivileges
}

//
//  setUp.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/26/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class setUp: NSObject{
    
    
    
    
    static func feedNav(navItem : UINavigationItem){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named:"BlankProfilePicture.png"), for: .normal)
        if let usersPhoto = BACurrentUser.currentUser.photoURL {
            let url = URL(string: usersPhoto)
            menuBtn.kf.setImage(with: url, for: .normal, placeholder: UIImage(named:"BlankProfilePicture.png"))
        }


        menuBtn.addTarget(self, action: #selector(FeedViewController.userSettings), for: UIControl.Event.touchUpInside)
        menuBtn.showsTouchWhenHighlighted = true
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        let radius = menuBtn.layer.frame.width/2.0
        menuBtn.layer.cornerRadius = radius
        menuBtn.layer.masksToBounds = true
        navItem.leftBarButtonItem = menuBarItem
    }
    
    
    static func filterButton(navItem : UINavigationItem){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 25)
        menuBtn.setImage(UIImage(named:"filter.png"), for: .normal)
        //menuBtn.addTarget(self, action: #selector(sideMenu), for: UIControlEvents.touchUpInside)
        menuBtn.showsTouchWhenHighlighted = true
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        navItem.rightBarButtonItem = menuBarItem

    }
    
    static func setUpNav(navCon: UINavigationController){
        navCon.navigationBar.barTintColor = .white
        navCon.navigationBar.isTranslucent = false
        navCon.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navCon.navigationBar.shadowImage = UIImage()
        navCon.navigationBar.tintColor = .black
    }
    
    static func setUpPicNav(navCon: UINavigationController){
        navCon.navigationBar.barTintColor = .black
        navCon.navigationBar.isTranslucent = false
        navCon.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navCon.navigationBar.shadowImage = UIImage()
        navCon.navigationBar.tintColor = .white
    }
    
    @objc func sideMenu(){
        print("Here")
    }
    
}

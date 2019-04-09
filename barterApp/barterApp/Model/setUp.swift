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
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 25)
        menuBtn.setImage(UIImage(named:"BlankProfilePicture.png"), for: .normal)
      //  menuBtn.addTarget(self, action: #selector(setUp.sideMenu), for: UIControl.Event.touchUpInside)
        menuBtn.showsTouchWhenHighlighted = true
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
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
    }
    
    @objc func sideMenu(){
        print("Here")
    }
    
}

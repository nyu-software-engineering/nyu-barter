//
//  CustomOverlay.swift
//  barterApp
//
//  Created by Kevin Maldjian on 8/8/18.
//  Copyright © 2018 Kevin Maldjian. All rights reserved.
//
import UIKit
import SwiftyOnboard
import Firebase
import GoogleSignIn


class CustomOverlay:SwiftyOnboardOverlay, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var contentControl: UIPageControl!


  //  @IBOutlet weak var signInButton: GIDSignInButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonContinue.layer.borderColor = UIColor.white.cgColor
        buttonContinue.layer.borderWidth = 1
        buttonContinue.layer.cornerRadius = buttonContinue.bounds.height / 2
    }

    

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func getStarted(_ sender: Any) {
        if(contentControl.currentPage == 2){
            print("SegueTime!")
            
    }
}
}

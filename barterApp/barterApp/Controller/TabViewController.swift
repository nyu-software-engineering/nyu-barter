//
//  TabViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/27/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

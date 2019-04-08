//
//  CustomPage.swift
//  rushApp
//
//  Created by Kevin Maldjian on 8/8/18.
//  Copyright © 2018 Kevin Maldjian. All rights reserved.
//

import UIKit
import SwiftyOnboard

class CustomPage: SwiftyOnboardPage {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}

//
//  Color.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/27/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}

//
//  ItemInfoViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/9/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit
import Hero

class ItemInfoViewController: UIViewController {
    
    var barterItem : BABarterItem!
    
    @IBOutlet weak var itemPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setUp.setUpPicNav(navCon: self.navigationController!)
       // print(barterItem.descr)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToFeed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

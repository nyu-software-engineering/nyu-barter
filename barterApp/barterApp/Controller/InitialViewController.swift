//
//  ViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/24/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//
import Foundation
import UIKit

class InitialViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    override func viewWillAppear() {
        //If needed
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        goMainScreen() //We are skipping login currently
        
    }
    
    
    
    func goMainScreen() {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let mainPage = storyboard.instantiateViewController(withIdentifier: "MainTab")
        self.present(mainPage, animated: true, completion: nil)
    }
    
    
}


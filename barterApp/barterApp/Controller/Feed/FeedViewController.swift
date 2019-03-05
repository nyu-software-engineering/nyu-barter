//
//  FeedViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/26/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    private var cellsSizes = [CGSize]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let items = ["1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2", "1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2", "1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "homeFeed"
        
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "home.png")
        self.tabBarController?.tabBar.tintColor = .black
        self.tabBarController?.tabBar.items?[0].selectedImage = UIImage(named: "homeSelected.png")
        
        //Navigation Setup
        setUp.feedNav(navItem: self.navigationItem)
        setUp.filterButton(navItem: self.navigationItem)
        setUp.setUpNav(navCon: self.navigationController!)
        
        //Search Bar Setup
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search BarterApp"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        }
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        
        
        //Collection View Setup
        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        cellsSizes = CellSizeProvider.provideSizes(items: items)
        collectionView.reloadData()
        
        
//        let button = UIButton()
//        button.setImage(UIImage(named: "addItem.png"), for: .normal)
//        button.sizeToFit()
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        self.tabBarController?.tabBar.addSubview(button)
//        self.tabBarController?.tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
//        self.tabBarController?.tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
//
//

    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCollectionViewCell
        //cell.lblTitle.text = items[indexPath.item]
        cell.background.backgroundColor = UIColor.random()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on cell %d", indexPath)
    }
    

}

extension FeedViewController: ContentDynamicLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.item]
    }
    
    
    }



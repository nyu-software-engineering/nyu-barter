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
    let items = ["1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2", ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
        setUp.feedNav(navItem: self.navigationItem)
        setUp.filterButton(navItem: self.navigationItem)
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search BarterApp"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        }
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        
        cellsSizes = CellSizeProvider.provideSizes(items: items)
        
        collectionView.reloadData()
        

    
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
    
    
    

}

extension FeedViewController: ContentDynamicLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.item]
    }
    
    
    }


/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

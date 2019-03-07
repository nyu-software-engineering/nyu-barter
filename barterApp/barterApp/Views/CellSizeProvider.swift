//
//  CellSizesProvider.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/27/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit

class CellSizeProvider {
    private static let kTagsPadding: CGFloat = 15
    private static let kMinCellSize: UInt32 = 50
    private static let kMaxCellSize: UInt32 = 100
    
    class func provideSizes(items: [String]) -> [CGSize] {
        var cellSizes = [CGSize]()
        var size: CGSize = .zero
        
        for item in items {
            size = CellSizeProvider.provideInstagramCellSize(item: item)
            cellSizes.append(size)
        }
        
        return cellSizes
    }
    
    private class func provideTagCellSize(item: String) -> CGSize {
        var size = UIFont.systemFont(ofSize: 17).sizeOfString(string: item, constrainedToWidth: Double(UIScreen.main.bounds.width))
        size.width += kTagsPadding
        size.height += kTagsPadding
        
        return size
    }
        
    private class func provideInstagramCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideRandomCellSize(item: String) -> CGSize {
        let width = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        let height = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        
        return CGSize(width: width, height: height)
    }
}

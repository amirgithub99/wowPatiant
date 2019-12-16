//
//  HomeCollectionViewLayout.swift
//  Wow Patient
//
//  Created by Amir on 03/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//
//
import UIKit

class HomeCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    var numberOfItemsPerRow: Int = 3 {
        didSet {
           // invalidateLayout()
        }
    }
    override func prepare()
    {
        super.prepare()
        if let collectionView = self.collectionView
        {
            var newItemSize = itemSize
            
            // Always use an item count of at least 1
            _ = CGFloat(max(numberOfItemsPerRow, 1))
            // Calculate the sum of the spacing between cells
            _ = CGFloat(10.0) // minimumInteritemSpacing * (itemsPerRow - 1.0)
            // Calculate how wide items should be
            //newItemSize.width = (collectionView.bounds.size.width - totalSpacing) / itemsPerRow
            let userDefaultt = UserDefaults.standard
            let collectionWidth = userDefaultt.integer(forKey: "collectionWidth")
             // collectionWidth = collectionWidth
            let widthPlusEquHeightValue = 20
            let cellWidthh =  CGFloat(collectionWidth / 2)
            let cellHeight = cellWidthh + CGFloat(widthPlusEquHeightValue)
            newItemSize.width = cellWidthh - 5
            newItemSize.height = cellHeight - 5
            //var minimumItemSpacing = collectionWidth - (Int(cellWidthh) * 2) - 10
            
            var minimumItemSpacing = Int((self.collectionView?.frame.size.width)!) - (Int(cellWidthh) * 2) - 10
          //  let minimumItemSpacing = collectionWidth - (Int(cellWidthh) * 2) - 10
            let collectionlandScapeWitdth = Int((self.collectionView?.bounds.size.width)!)
            let portraitWitdh = collectionWidth + 10
            if collectionlandScapeWitdth > portraitWitdh
            {
                // landS
                  minimumItemSpacing = Int((self.collectionView?.bounds.size.width)!) - (Int(cellWidthh) * 2) - 1
                let leftMargin = CGFloat(minimumItemSpacing) * 0.25
                self.sectionInset = UIEdgeInsetsMake(10, leftMargin, 10, leftMargin)
            }
            
            else
            {
                // portrait Mode
                self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
            }
            itemSize = newItemSize
            self.invalidateLayout()
        }
    }
} // end class



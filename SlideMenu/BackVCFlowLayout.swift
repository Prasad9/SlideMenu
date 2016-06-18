//
//  BackVCFlowLayout.swift
//  SlideMenu
//
//  Created by Prasad Pai on 06/06/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

class BackVCFlowLayout: UICollectionViewFlowLayout {
    
    let baseHeight: CGFloat = 60.0
    var offsetX: CGFloat = 0 {
        willSet {
            let screenSize = UIScreen.mainScreen().bounds.size
            let cellHeight = baseHeight + 2.0 * (screenSize.height - 150.0) * newValue
            self.cellItemSize = CGSize(width: screenSize.width, height: cellHeight)
            self.invalidateLayout()
        }
    }
    var cellItemSize = CGSize(width: 1.0, height: 1.0)
    
    // MARK: Life Cycle methods
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func prepareLayout() {
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
        self.itemSize = self.cellItemSize
    }
}

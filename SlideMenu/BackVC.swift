//
//  BackVC.swift
//  SlideMenu
//
//  Created by Prasad Pai on 05/06/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

protocol BackVCProtocol: class {
    func backVCMenuItemTapped()
}

class BackVC: UIViewController {
    
    weak var backVCDelegate: BackVCProtocol?
    
    @IBOutlet private weak var headingLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let backVCFlowLayout = BackVCFlowLayout()
    private let menuList = ["News Feed", "Profile", "Settings", "About Us"]

    // MARK: View Controller Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.collectionViewLayout = self.backVCFlowLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public methods
    func makeUIAdjustmentsWithPercent(percent: CGFloat) {
        let screenSize = UIScreen.mainScreen().bounds.size
        self.headingLabelLeadingConstraint.constant = percent * screenSize.width
        self.backVCFlowLayout.offsetX = percent
        self.view.layoutIfNeeded()
    }
}

extension BackVC: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: CollectionView Data Source methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! LabelCell
        cell.itemLabel.text = self.menuList[indexPath.row]
        return cell
    }
    
    // MARK: CollectionView Delegate methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.backVCDelegate?.backVCMenuItemTapped()
    }
}

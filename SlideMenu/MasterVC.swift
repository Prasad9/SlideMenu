//
//  MasterVC.swift
//  SlideMenu
//
//  Created by Prasad Pai on 05/06/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

enum ViewControllers: String {
    case FrontVC
    case BackVC
    
    static func getViewController<T>(vc: ViewControllers) -> T {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let genericVC = storyBoard.instantiateViewControllerWithIdentifier(vc.rawValue) as! T
        return genericVC
    }
}

// MARK: Constants
private let kThresholdPointsLimit = 0

private let kMinimizedScaledX: CGFloat = 0.9
private let kMinimizedScaledY: CGFloat = 0.65
private let kMinimizedScaledZ: CGFloat = 1.0

private let kTimerCallRateIdentifier = "timerCallRateIdentifier"
private let kLeftOutPercentIdentifier = "leftOutPercentIdentifier"
private let kChangePercentByIdentifier = "changePercentByIdentifier"
private let kIsCoveringFrontVCIdentifier = "isCoveringFrontVCIdentifier"
private let kAnimationDuration = 0.4

class MasterVC: UIViewController {
    
    private var backVC: BackVC?
    private var frontVC: FrontVC?
    
    private var leftMostPointX: CGFloat { return 8.0 }
    private var rightMostPointX: CGFloat { return 0.6 * UIScreen.mainScreen().bounds.width }
    
    private var thresholdPointsAt = 0
    private var isThresholdPointsCrossed = false
    private var previousPointX: CGFloat = 0.0
    private var isViewShowingFrontView = true
    private var isFrontViewMovingLeft = false
    
    // MARK: View Controller Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBounds = UIScreen.mainScreen().bounds
        self.backVC = ViewControllers.getViewController(ViewControllers.BackVC) as BackVC
        self.backVC?.backVCDelegate = self
        self.backVC?.view.frame = screenBounds
        self.addChildViewController(self.backVC!)
        self.view.addSubview((self.backVC?.view)!)
        self.backVC?.didMoveToParentViewController(self)

        self.frontVC = ViewControllers.getViewController(ViewControllers.FrontVC) as FrontVC
        self.frontVC?.frontVCDelegate = self
        self.frontVC?.view.frame = screenBounds
        self.addChildViewController(self.frontVC!)
        self.view.addSubview((self.frontVC?.view)!)
        self.frontVC?.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    private func alterFrontViewAnimation(showFrontView showFrontView: Bool) {
        if showFrontView {
            UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
                self.frontVC?.view.transform = CGAffineTransformIdentity
                }) { finished in
                    self.isViewShowingFrontView = true
                    self.frontVC?.overlayBtn?.hidden = true
            }
        }
        else {
            var transform = CATransform3DScale(CATransform3DIdentity, kMinimizedScaledX, kMinimizedScaledY, kMinimizedScaledZ)
            transform = CATransform3DTranslate(transform, self.rightMostPointX, 0.0, 0.0)
            UIView.animateWithDuration(kAnimationDuration, animations: {
                self.frontVC?.view.layer.transform = transform
            }) { finished in
                self.isViewShowingFrontView = false
                self.frontVC?.overlayBtn?.hidden = false
            }
        }
    }
    
    private func alterBackVCLayout(showFrontView showFrontView: Bool, initialPointXAt pointX: CGFloat) {
        let distanceToMove = showFrontView ? pointX - self.leftMostPointX : self.rightMostPointX - pointX
        if distanceToMove > 0 {
            let totalDistanceAvailableToMove = self.rightMostPointX - self.leftMostPointX
            let timeSpan = Double(distanceToMove / totalDistanceAvailableToMove) * kAnimationDuration
            let distancePercentLeftOut = distanceToMove / totalDistanceAvailableToMove
            let totalFrames = 40.0
            let timerCallRate = timeSpan / totalFrames
            let changePercentBy = distancePercentLeftOut / CGFloat(totalFrames)
            let userInfo: [String: AnyObject] = [kTimerCallRateIdentifier: timerCallRate,
                                                 kLeftOutPercentIdentifier: distancePercentLeftOut,
                                                 kChangePercentByIdentifier: changePercentBy,
                                                 kIsCoveringFrontVCIdentifier: showFrontView]
            NSTimer.scheduledTimerWithTimeInterval(timerCallRate, target: self, selector: #selector(backVCLayoutTimerHit(_:)), userInfo: userInfo, repeats: false)
        }
    }
    
    // MARK: Selector methods
    func backVCLayoutTimerHit(timer: NSTimer) {
        if let userInfo = timer.userInfo as! [String: AnyObject]?,
            timerCallRate = userInfo[kTimerCallRateIdentifier] as! Double?,
            distancePercentLeftOut = userInfo[kLeftOutPercentIdentifier] as! CGFloat?,
            changePercentBy = userInfo[kChangePercentByIdentifier] as! CGFloat?,
            showFrontView = userInfo[kIsCoveringFrontVCIdentifier] as! Bool? {
            
            let offsetX = showFrontView ? 1.0 - distancePercentLeftOut : distancePercentLeftOut
            self.backVC?.makeUIAdjustmentsWithPercent(offsetX)
            
            if distancePercentLeftOut > 0.0 {
                let nextDistancePercentLeftOut = distancePercentLeftOut - changePercentBy > 0.0 ? distancePercentLeftOut - changePercentBy : 0.0
                let updatedUserInfo: [String: AnyObject] = [kTimerCallRateIdentifier: timerCallRate,
                                                            kLeftOutPercentIdentifier: nextDistancePercentLeftOut,
                                                            kChangePercentByIdentifier: changePercentBy,
                                                            kIsCoveringFrontVCIdentifier: showFrontView]
                NSTimer.scheduledTimerWithTimeInterval(timerCallRate, target: self, selector: #selector(backVCLayoutTimerHit(_:)), userInfo: updatedUserInfo, repeats: false)
            }
        }
    }
    
    // MARK: Utility methods
    private func getAffineTransformForPosX(posX: CGFloat) -> CATransform3D {
        let totalDistanceToMove = self.rightMostPointX - self.leftMostPointX
        let movedPosX = (posX - self.leftMostPointX > 0) ? (posX - self.leftMostPointX) : 0
        
        if movedPosX > totalDistanceToMove {
            var transform = CATransform3DScale(CATransform3DIdentity, kMinimizedScaledX, kMinimizedScaledY, kMinimizedScaledZ)
            transform = CATransform3DTranslate(transform, self.rightMostPointX, 0.0, 0.0)
            return transform
        }
        
        let percent = (totalDistanceToMove - movedPosX) / totalDistanceToMove
        let percentScaleX = kMinimizedScaledX + percent * (1.0 - kMinimizedScaledX)
        let percentScaleY = kMinimizedScaledY + percent * (1.0 - kMinimizedScaledY)
        let percentScaleZ = kMinimizedScaledZ + percent * (1.0 - kMinimizedScaledZ)
        let pointX = min(movedPosX, self.rightMostPointX)
        var transform = CATransform3DScale(CATransform3DIdentity, percentScaleX, percentScaleY, percentScaleZ)
        transform = CATransform3DTranslate(transform, pointX, 0.0, 0.0)
        return transform
    }
}

// MARK: FrontVC Delegate methods
extension MasterVC: FrontVCProtocol {
    func frontVCMenuBtnTapped() {
        let showFrontView = self.isThresholdPointsCrossed ? self.isFrontViewMovingLeft : !self.isViewShowingFrontView
        
        if self.thresholdPointsAt > 0 {
            self.alterBackVCLayout(showFrontView: showFrontView, initialPointXAt: self.previousPointX)
        }
        else {
            self.alterBackVCLayout(showFrontView: showFrontView, initialPointXAt: showFrontView ? self.rightMostPointX : self.leftMostPointX)
        }
        self.alterFrontViewAnimation(showFrontView: showFrontView)
        
        self.thresholdPointsAt = 0
        self.isThresholdPointsCrossed = false
    }
    
    func frontVCMenuBtnDraggedWithSender(sender: AnyObject, event: UIEvent) {
        if let button = sender as? UIButton {
            if let touchSet = event.touchesForView(button) {
                let touch = touchSet[touchSet.startIndex]
                let point = touch.locationInView(self.view)
                
                if self.isThresholdPointsCrossed {
                    if previousPointX != point.x {
                        self.isFrontViewMovingLeft = (self.previousPointX - point.x > 0) ? true : false
                        self.previousPointX = point.x
                    }
                }
                else {
                    self.thresholdPointsAt += 1
                    self.isThresholdPointsCrossed = (self.thresholdPointsAt > kThresholdPointsLimit) ? true : false
                }
                
                let distanceLeftToMove = self.rightMostPointX - point.x
                if distanceLeftToMove > 0 {
                    let transform = self.getAffineTransformForPosX(point.x)
                    frontVC?.view.layer.transform = transform
                    
                    let percentLeftOut = distanceLeftToMove / (self.rightMostPointX - self.leftMostPointX)
                    self.backVC?.makeUIAdjustmentsWithPercent(percentLeftOut)
                }
            }
        }
    }
    
    func frontVCOverlayBtnTapped() {
        self.alterFrontViewAnimation(showFrontView: true)
        self.alterBackVCLayout(showFrontView: true, initialPointXAt: self.rightMostPointX)
    }
}

// MARK: BackVC Delegate methods
extension MasterVC: BackVCProtocol {
    func backVCMenuItemTapped() {
        self.alterFrontViewAnimation(showFrontView: true)
        self.alterBackVCLayout(showFrontView: true, initialPointXAt: self.rightMostPointX)
    }
}


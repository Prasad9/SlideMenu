//
//  CGPointExtension.swift
//  SlideMenu
//
//  Created by Prasad Pai on 6/20/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

extension CGPoint {
    static func subtractPoint(pointA: CGPoint?, withPoint pointB: CGPoint?) -> CGPoint {
        if let pointA = pointA, pointB = pointB {
            let subtractedPoint = CGPoint(x: pointA.x - pointB.x, y: pointA.y - pointB.y)
            return subtractedPoint
        }
        else if let pointA = pointA {
            return pointA
        }
        else if let pointB = pointB {
            return CGPoint(x: pointB.x, y: pointB.y)
        }
        return CGPoint.zero
    }
}

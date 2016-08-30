//
//  Functions.swift
//  BarBreaker
//
//  Created by Viktor on 29/08/16.
//  Copyright © 2016 viggurt. All rights reserved.
//

import Foundation
import CoreGraphics


func / (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x/scalar, y: left.y/scalar)
}

func + (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x+scalar, y: left.y+scalar)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x, y: left.y+right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func <= (left: CGVector, right: CGVector) -> Bool {
    return (left.dx <= right.dx) && (left.dy <= right.dy)
}

extension CGPoint {
    var angle: CGFloat {
        return atan2(y,x)
    }
}
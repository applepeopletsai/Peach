//
//  CALayer_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        addSublayer(border)
    }
    func setBorder(width:CGFloat, color:CGColor, round:CGFloat) {
        self.borderWidth = width
        self.borderColor = color
        self.cornerRadius = round
        self.masksToBounds = true
    }
    func setRound() {
        self.layoutIfNeeded()
        self.cornerRadius = self.frame.height / 2
        self.masksToBounds = true
    }
    func setRoundWith(radius:CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
    }
    //setRoundCorners(cornors: [.topLeft,.topRight], cornerRadius: 10)
    func setRoundCorners(cornors: UIRectCorner,cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornors, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.mask = maskLayer
        
    }
    
    func removeAllSublayers() {
        for layer in self.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
    }
}

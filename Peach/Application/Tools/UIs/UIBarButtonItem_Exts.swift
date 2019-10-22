//
//  UIBarButtonItem_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0;
//MARK: - UIBarButtonItem
extension UIBarButtonItem {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    /// Set badge
    func setBadge(text: String?,
                  withOffsetFromTopRight offset: CGPoint = .zero,
                  andColor color:UIColor = .red,
                  andFilled filled: Bool = true,
                  andFontSize fontSize: CGFloat = 11) {
        
        badgeLayer?.removeFromSuperlayer()
        
        if (text == nil || text == "") {
            return
        }
        
        addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
    }
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    private func addBadge(text: String,
                          withOffset offset: CGPoint = .zero,
                          andColor color: UIColor = .red,
                          andFilled filled: Bool = true,
                          andFontSize fontSize: CGFloat = 11) {
        
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        var font = UIFont.systemFont(ofSize: fontSize)
        
        if #available(iOS 9.0, *) {
            font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        }
        
        let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        // Initialize Badge
        let badge = CAShapeLayer()
        
        let height = badgeSize.height;
        var width = badgeSize.width + 2 /* padding */
        
        //make sure we have at least a circle
        if (width < height) {
            width = height
        }
        
        //x position is offset from right-hand side
        
        let x = view.frame.width - width + offset.x
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))
        
        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let labelLayer = CATextLayer()
        labelLayer.string = text
        labelLayer.alignmentMode = CATextLayerAlignmentMode.center
        labelLayer.font = font
        labelLayer.fontSize = font.pointSize
        
        labelLayer.frame = badgeFrame
        labelLayer.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        labelLayer.backgroundColor = UIColor.clear.cgColor
        labelLayer.contentsScale = UIScreen.main.scale
        badge.addSublayer(labelLayer)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    
}

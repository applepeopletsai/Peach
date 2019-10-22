//
//  UILabel_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UILabel {
    func setPingFangFont(size:CGFloat) {
        self.font = UIFont(name: "PingFangTC-Regular", size: size)
    }
    
    func changeDigitLettersColor(to color: UIColor) {
        guard let labelText = self.text else { return }
        
        let attributedString = (self.attributedText != nil) ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: labelText)
        
        let digits = CharacterSet.decimalDigits
        
        var result:[[Int]] = []
        var range:[Int] = []
        for (index,value) in labelText.unicodeScalars.enumerated() {
            
            if digits.contains(value) {
                if range.isEmpty {
                    range.append(index)
                }
            } else {
                if !range.isEmpty {
                    range.append(index - 1)
                }
                if range.count == 2 {
                    result.append(range)
                    range.removeAll()
                }
            }
            if index == labelText.count - 1, range.count != 0 {
                range.append(index)
                result.append(range)
            }
        }
        for range in result {
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: range.first!, length: range.last! - range.first! + 1))
        }
        self.attributedText = attributedString
    }
    
    static func customLabelWith(title:String?,font:UIFont,textColor:UIColor,backGroundColor:UIColor?) -> UILabel {
        let newLabel = self.init(frame: CGRect.zero)
        newLabel.font = font
        newLabel.textColor = textColor
        if (backGroundColor != nil) {
            newLabel.backgroundColor = backGroundColor
        }
        if title != nil {
            newLabel.text = title
        }
        return newLabel
    }
    
    
    
}

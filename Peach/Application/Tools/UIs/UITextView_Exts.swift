//
//  UITextView_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UITextView {
    func appendLinkString(string: String, withURLString: String = "") {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(attributedText)
        
        let attrs = [NSAttributedString.Key.font: self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes: attrs)
        
        if withURLString != "" {
            let range: NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value: withURLString, range: range)
            appendString.endEditing()
        }
        
        attrString.append(appendString)
        
        attributedText = attrString
    }
}

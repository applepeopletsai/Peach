//
//  CGFloat_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    //以4 inch螢幕為主
    static func get4InchBaseXOrWidth(x:CGFloat) -> CGFloat {
        
        let screenPortraitWidth = UIScreen.main.nativeBounds.width
        let baseWidth:CGFloat = 640.0
        let fX:CGFloat = screenPortraitWidth * (x * 2.0 / baseWidth)
        
        return fX
        
    }
    static func get4InchBaseYOrHeight(x:CGFloat) -> CGFloat {
        let screenPortraitHeight = UIScreen.main.nativeBounds.height
        let baseHeight:CGFloat = 1136.0
        let fY:CGFloat = screenPortraitHeight * (x * 2.0 / baseHeight)
        return fY
    }
    static func get4InchBaseWidthPoint(x:CGFloat) -> CGFloat {
        
        let screenPortraitWidth = UIScreen.main.bounds.width
        let baseWidth:CGFloat = 640.0
        let fX:CGFloat = screenPortraitWidth * (x * 2.0 / baseWidth)
        
        return fX
        
    }
    
}

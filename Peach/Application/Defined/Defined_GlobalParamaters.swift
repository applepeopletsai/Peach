//
//  Defined_GlobalParamaters.swift
//  Peach
//
//  Created by dean on 2019/8/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

typealias ClosureArrange                     = (CGRect, Int) -> Void;


let kScreenSize                             = UIScreen.main.bounds.size
let kScreenWidth                            = kScreenSize.width
let kScreenHeight                           = kScreenSize.height
@available(iOS 11.0, *)
let kSafeArea                               = UIApplication.shared.keyWindow?.safeAreaInsets

let kCommonLeftPadding: CGFloat             = 10
let kCommonRightPadding: CGFloat            = 10
let kCommonTopPadding: CGFloat              = 10
let kCommonBottomPadding: CGFloat           = 10

let kStatusBarHeight: CGFloat               = 20.0

let rBaseWidth: CGFloat                     = 640.0
let rBaseHeight: CGFloat                    = 1136.0

let defaultTimeoutInterval: TimeInterval    = 30

func rWidth(_ value: CGFloat) -> CGFloat {
    return ceil(kScreenWidth * (value * 2.0 / rBaseWidth))
}
func rHeight(_ value: CGFloat) -> CGFloat {
    return ceil(kScreenWidth * (value * 2.0 / rBaseWidth))
}

func kTrunc(_ x: Double) -> Double {
    return trunc(x * 10000.0) / 10000.0
}

//MARK:Public Static Function
func arrangeTile(withCol col:Int, withRow row:Int, withCellSize cellSize:CGSize, withCellOffset cellOffset:CGPoint, withCellGap cellGap:CGPoint, withTagOffset tagOffset:Int, withClosuresArrange closuresArrange:ClosureArrange)
{
    var index:Int = 0;
    for i in 0..<row{
        for t in 0..<col{
            let x:CGFloat = cellOffset.x + CGFloat(t) * (cellSize.width + cellGap.x);
            let y:CGFloat = cellOffset.y + CGFloat(i) * (cellSize.height + cellGap.y);
            let width:CGFloat = cellSize.width;
            let height:CGFloat = cellSize.height;
            //print("i = \(i)  t = \(t)  index = \(index)")
            closuresArrange(CGRect(x: x, y: y, width: width, height: height), index + tagOffset);
            index += 1;
        }
    }
}

//Iphone_X XR XS XSMax
let Is_Iphone = (UI_USER_INTERFACE_IDIOM() == .phone)

let Is_Iphone_X_XS_XR_XSMAX = (Is_Iphone &&  kScreenHeight >= 812)
// STATUS_BAR高度
let STATUS_BAR_HEIGHT = Is_Iphone_X_XS_XR_XSMAX ? 44 : 20
// NAVIGATION_BAR高度
let NAVIGATION_BAR_HEIGHT  = Is_Iphone_X_XS_XR_XSMAX ? 88 : 64
// tabBar高度
let TAB_BAR_HEIGHT = Is_Iphone_X_XS_XR_XSMAX ? 49 + 34 : 49
// home indicator
let HOME_INDICATOR_HEIGHT = Is_Iphone_X_XS_XR_XSMAX ? 34 : 0

public typealias ActionHandler = () -> Void

var viewPressed: (() -> (Void))?

enum GlobalConstants {
    static let cardHighlightedFactor: CGFloat = 0.96
    static let statusBarAnimationDuration: TimeInterval = 0.4
    static let cardCornerRadius: CGFloat = 16
    static let dismissalAnimationDuration = 0.6
    
    static let cardVerticalExpandingStyle: CardVerticalExpandingStyle = .fromTop
    
    
    /// Without this, there'll be weird offset (probably from scrollView) that obscures the card content view of the cardDetailView.
    static let isEnabledWeirdTopInsetsFix = true
    
    /// If true, will draw borders on animating views.
    static let isEnabledDebugAnimatingViews = false
    
    /// If true, this will add a 'reverse' additional top safe area insets to make the final top safe area insets zero.
    static let isEnabledTopSafeAreaInsetsFixOnCardDetailViewController = false
    
    /// If true, will always allow user to scroll while it's animated.
    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true
    
    static let isEnabledDebugShowTimeTouch = true
    
    enum CollectionCellSize {
        static let width_twoSeperate = UIScreen.width() / 2 - 30
        static let width_300 = 300
        static let height_500 = 500
        
    }
}

extension GlobalConstants {
    enum CardVerticalExpandingStyle {
        /// Expanding card pinning at the top of animatingContainerView
        case fromTop
        
        /// Expanding card pinning at the center of animatingContainerView
        case fromCenter
    }
    
    
}

#if ALPHA
let kDomainJsonKey                          = "1234567890123456"
let kSignAppKey                             = "JrWHDSK0xdWREmN5SJbdGD3DP5AN7mTA"
let kSignSecret                             = "2c6979b34a41f17f91d5f8bf28ddc9e2"
#else
let kDomainJsonKey                          = "1234567890123456"
let kSignAppKey                             = "JrWHDSK0xdWREmN5SJbdGD3DP5AN7mTA"
let kSignSecret                             = "2c6979b34a41f17f91d5f8bf28ddc9e2"
#endif

//
//  Defind_UI_Color.swift
//  Peach
//
//  Created by dean on 2019/9/5.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum ColorCode: String {
        //MARK: 白
        case color_white = "FFFFFF"
        
        //MARK: 灰
        case color_gray_1 = "404040"
        case color_gray_2 = "838383"
        case color_gray_3 = "DEDEDE"
        
        case color_placeHolder = "C7C7C7"
        
        //MARK: 紅
        case color_pink_1 = "FFD6E2"
        case color_pink_2 = "FF6E96"
        case color_pink_3 = "FF336C"
        case color_pink_4 = "B53256"
        case color_pink_5 = "DB473B"
        
        //MARK: 綠
        case color_green_1 = "3BDBAA"
        
        //MARK: 金
        case color_gold_1 = "E8CD95"
        case color_gold_2 = "CBA465"
    }
    
    public enum ColorStyle {
        case color_text_1
        case color_text_2
        case color_text_3
        case color_text_4
        case color_text_5
        case color_text_6
        case color_text_7
        case color_text_8
        case color_text_9
        case color_placeHolder
        case pink_1
        
        fileprivate func colorCode() -> ColorCode {
            
            var result:ColorCode = .color_white
            switch self {
            case .color_text_1:
                result = .color_white
            case .color_text_2:
                result = .color_gray_1
            case .color_text_3:
                result = .color_gray_2
            case .color_text_4:
                result = .color_gray_3
            case .color_text_5:
                result = .color_pink_2
            case .color_text_6:
                result = .color_pink_3
            case .color_text_7:
                result = .color_pink_5
            case .color_text_8:
                result = .color_green_1
            case .color_text_9:
                result = .color_gold_2
            case .color_placeHolder:
                result = .color_placeHolder
            case .pink_1:
                result = .color_pink_1
            }
            return result
        }
        
    }

    //MARK: Public Static Function
    public static func customColor(_ colorType:ColorStyle) -> UIColor {
        let colorCode:ColorCode = colorType.colorCode()
        return UIColor.colorWithHexString(hex: colorCode.rawValue)
    }
    
    
}

//
//  Defind_UI_Font.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct CustomFontConstant {
    static var fontNameRegular:String = "Helvetica Neue Regular"
    static var fontNameBold:String = "Helvetica Neue Bold"
    static var fontNameMedium:String = "Helvetica Neue Medium"
    static var fontNameLight:String = "Helvetica Neue Light"
}

extension UIFont {

    public enum CustomFontType {
        //MARK: 標題
        case font_title_big                 //大標題
        case font_title_secondbig           //次大標題
        case font_title_sbig_thin           //次大細標題
        case font_title_medium              //中標
        case font_title_small               //小標
        
        //MARK: 內容
        case font_text_extrabig             //特大內文
        case font_text_big                  //大內文
        case font_text_secondbig            //次大內文
        case font_text_medium               //中內文
        case font_text_small                //小內文
        case font_text_smallest             //最小內文

        //MARK: 內容
        case font_other                     //其他
        case font_other_big                 //評分
        
        func fontInfo() -> (fontName: String, fontSize:CGFloat, fontWeight:UIFont.Weight) {
            var size:CGFloat = 0
            var name:String = ""
            var weight:UIFont.Weight = .regular
            
            switch self {
            case .font_title_big:
                size = 36
                name = CustomFontConstant.fontNameBold
                weight = .bold
                
            case .font_title_secondbig:
                size = 28
                name = CustomFontConstant.fontNameBold
                weight = .bold
                
            case .font_title_sbig_thin:
                size = 28
                name = CustomFontConstant.fontNameRegular
                weight = .regular
                
            case .font_title_medium:
                size = 24
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_title_small:
                size = 20
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_text_extrabig:
                size = 60
                name = CustomFontConstant.fontNameMedium
                weight = .medium

            case .font_text_big:
                size = 36
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_text_secondbig:
                size = 28
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_text_medium:
                size = 24
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_text_small:
                size = 20
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_text_smallest:
                size = 18
                name = CustomFontConstant.fontNameRegular
                weight = .regular

            case .font_other:
                size = 46
                name = CustomFontConstant.fontNameMedium
                weight = .medium

            case .font_other_big:
                size = 70
                name = CustomFontConstant.fontNameLight
                weight = .light
            }
            
            size /= 2.0
            
            return (fontName: name, fontSize: size, fontWeight: weight)
        }
        
    }

    //MARK: Public Static Function
    public static func customFont(_ fontType:CustomFontType) -> UIFont {
        let fontInfo = fontType.fontInfo()
        //2019.10.15
        //Justin
        //先使用systemFont + size + weight
        //待確認設計師指定字體fontName後再做更換
//        return UIFont(name: fontInfo.fontName, size: fontInfo.fontSize)!
        return UIFont.systemFont(ofSize: fontInfo.fontSize, weight: fontInfo.fontWeight)
    }
    
    
}

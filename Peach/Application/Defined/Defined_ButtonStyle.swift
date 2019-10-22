//
//  Defined_ButtonStyle.swift
//  Peach
//
//  Created by DaWei Liao on 2019/9/2.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIButton {
    
    enum ButtonStyle {
        case Submit             //確認按鈕
    }
    
    func updateToStyle(style:ButtonStyle) -> Void
    {
        if style == .Submit{
            
            let colorBackground:UIColor = UIColor.customColor(.color_text_6)
            let colorTitle:UIColor = .white;
            
            self.setBackgroundImage(UIImage.returnImageWithColorAndSize(color: colorBackground, size: CGSize(width: 320, height: 320)), for: .normal);
            self.setTitleColor(colorTitle, for: .normal);
            self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            self.layer.masksToBounds = true;
            
            self.width(constant: rWidth(130.0));
            self.height(constant: 33.0);
            if let constant = self.heightConstaint?.constant{
                self.layer.cornerRadius = constant / 2.0;
            }
            self.layoutIfNeeded();
            
        }
    }
    
    
}

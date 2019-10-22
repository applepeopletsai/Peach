//
//  UIScreen_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIScreen {
    func screenWidth() -> CGFloat {
        return self.bounds.width
    }
    func screenHeight() -> CGFloat {
        return self.bounds.height
    }
    static func width() -> CGFloat {
        return self.main.bounds.width
    }
    static func height() -> CGFloat {
        return self.main.bounds.height
    }
}

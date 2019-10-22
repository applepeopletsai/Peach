//
//  IBInspectableImageView.swift
//  Peach
//
//  Created by Daniel on 5/09/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class IBInspectableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleEnable: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if circleEnable {
            self.layer.cornerRadius = self.bounds.size.height / 2
        }
    }
}

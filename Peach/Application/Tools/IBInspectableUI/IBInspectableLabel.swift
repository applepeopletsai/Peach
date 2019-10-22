//
//  IBInspectableLabel.swift
//  Peach
//
//  Created by Daniel on 5/09/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class IBInspectableLabel: UILabel {
    
    private var originalTextColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalTextColor = self.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        originalTextColor = self.textColor
    }
    
    override var text: String? {
        didSet {
            if let t = text {
                if t.count == 0 {
                    showEmptyText()
                } else {
                    self.textColor = originalTextColor
                }
            } else {
                showEmptyText()
            }
        }
    }
    
    @IBInspectable var emptyTextLocalizedKey: String? {
        didSet {
            showEmptyText()
        }
    }
    
    @IBInspectable var emptyTextColor: UIColor? {
        didSet {
            showEmptyText()
        }
    }
    
    @IBInspectable var titleLocalizedKey: String? {
        didSet {
            if let titleLocalizedKey = titleLocalizedKey {
                super.text = titleLocalizedKey.localized
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
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
    
    private func showEmptyText() {
        if let emptyTextLocalizedKey = emptyTextLocalizedKey {
            super.text = emptyTextLocalizedKey.localized
            self.textColor = emptyTextColor
        }
    }
}

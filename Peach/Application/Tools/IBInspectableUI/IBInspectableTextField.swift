//
//  IBInspectableTextField.swift
//  Peach
//
//  Created by Daniel on 4/09/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class IBInspectableTextField: UITextField {
    
    private var leftImageViewWidth: CGFloat {
        return self.bounds.size.height * 0.46
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var placeHolderLocolizedKey: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var placeHoldercolor: UIColor = UIColor.customColor(.color_placeHolder) {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var leftImageName: String? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftImagePadding: CGFloat = 0.0
    
    @IBInspectable var textPadding: CGFloat = 0.0
    
    private func updateView() {
        if let leftImageName = leftImageName {
            self.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftImagePadding, y: 0, width: leftImageViewWidth, height: leftImageViewWidth))
            imageView.image = UIImage(named: leftImageName)
            imageView.contentMode = .scaleAspectFit
            self.leftView = imageView
        } else {
            self.leftViewMode = .never
            self.leftView = nil
        }
    }
    
    private func updatePlaceholder() {
        if let placeHolderLocolizedKey = placeHolderLocolizedKey {
            self.attributedPlaceholder =
                NSAttributedString(string: placeHolderLocolizedKey.localized, attributes: [NSAttributedString.Key.foregroundColor: placeHoldercolor])
        }
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var bounds = bounds
        bounds.origin.x += textPadding
        bounds.size.width -= textPadding
        if leftView != nil {
            bounds.origin.x += (leftImageViewWidth + leftImagePadding)
            bounds.size.width -= (leftImageViewWidth + leftImagePadding)
        }
        return bounds
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var bounds = bounds
        bounds.origin.x += textPadding
        bounds.size.width -= textPadding
        if leftView != nil {
            bounds.origin.x += (leftImageViewWidth + leftImagePadding)
            bounds.size.width -= (leftImageViewWidth + leftImagePadding)
        }
        return bounds
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftImagePadding
        return textRect
    }
}

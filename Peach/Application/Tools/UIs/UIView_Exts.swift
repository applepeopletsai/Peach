//
//  UIView_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIView {
    

    
    //=====  Constrant  =====
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: nil,
                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func returnConstaint(withItem item:AnyObject, withAtttibute attribute:NSLayoutConstraint.Attribute) -> NSLayoutConstraint?
    {
        var result:NSLayoutConstraint?
        for constraint in self.constraints{
            if let itemFirst = constraint.firstItem as? UIView, let itemCompare = item as? UIView{
                if itemFirst == itemCompare {
                    if constraint.firstAttribute == attribute && constraint.relation == .equal{
                        result = constraint;
                    }
                }
            }
        }
        return result;
    }
    
    func setLayerRounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    //=====  手勢  =====
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    //=====  旋轉  =====
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        layer.add(animation, forKey: nil)
    }
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    //=====  XIB  =====
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    // Bezier 設圓角
    func roundCorners(cornors: UIRectCorner,cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornors, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    func setFrameWith4InchSize(x:Double, y:Double, width: Double, height: Double) {
        //取得螢幕大小
        let screenPortraitHeight = Double(UIScreen.main.nativeBounds.height)
        let screenPortraitWidth = Double(UIScreen.main.nativeBounds.width)
        //以4 inch螢幕為主
        let baseHeight = 1136.0
        let baseWidth = 640.0
        let fX = screenPortraitWidth * (x * 2.0 / baseWidth)
        let fY = screenPortraitHeight * (x * 2.0 / baseHeight)
        let fHeight = screenPortraitHeight * (height * 2.0 / baseHeight)
        let fWidth = screenPortraitWidth * (width * 2.0 / baseWidth)
        self.frame = CGRect(x: fX, y: fY, width: fWidth, height: fHeight)
    }
    func setSquareFrameWith4InchSize(x:Double, y:Double, widthOrHeight: Double) {
        //取得螢幕大小
        let screenPortraitHeight = Double(UIScreen.main.nativeBounds.height)
        let screenPortraitWidth = Double(UIScreen.main.nativeBounds.width)
        //以4 inch螢幕為主
        let baseHeight = 1136.0
        let baseWidth = 640.0
        let fX = screenPortraitWidth * (x * 2.0 / baseWidth)
        let fY = screenPortraitHeight * (x * 2.0 / baseHeight)
        let fHeight = screenPortraitHeight * (widthOrHeight * 2.0 / baseHeight)
        
        self.frame = CGRect(x: fX, y: fY, width: fHeight, height: fHeight)
    }
    /// 宽度
    var base4InchWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            let baseWidth = 640.0
            let screenPortraitWidth = Double(UIScreen.main.nativeBounds.width)
            self.frame.size.width = CGFloat(screenPortraitWidth) * (newValue * 2.0 / CGFloat(baseWidth))
        }
    }
    /// 高度
    var base4InchHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            let screenPortraitHeight = Double(UIScreen.main.nativeBounds.height)
            let baseHeight = 1136.0
            
            self.frame.size.height = CGFloat(screenPortraitHeight) * (newValue * 2.0 / CGFloat(baseHeight))
        }
    }
    /// 尺寸
    var base4InchSize: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            let baseWidth = 640.0
            let screenPortraitWidth = Double(UIScreen.main.nativeBounds.width)
            let screenPortraitHeight = Double(UIScreen.main.nativeBounds.height)
            let baseHeight = 1136.0
            self.frame.size = CGSize(width: CGFloat(screenPortraitWidth) * (newValue.width * 2.0 / CGFloat(baseWidth)), height: CGFloat(screenPortraitHeight) * (newValue.height * 2.0 / CGFloat(baseHeight)))
        }
    }
    //=====  Constrain  =====
    func addWidthConstrain(width:CGFloat) {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    func addHeightConstrain(height:CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func edges(to view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            ])
    }
    // screenShot
    func takeScreenshot(shouldSave: Bool = true) -> UIImage {
        
        // Begin context
        //self.bounds.size
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.width, height: self.bounds.height - 200), false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: CGRect(x: 0.0, y: self.bounds.origin.y - 60, width: self.bounds.width, height: self.bounds.height)//self.bounds
            , afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = image, shouldSave {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        }
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    func takeScreenshot(rect:CGRect,shouldSave: Bool = true) -> UIImage {
        
        // Begin context
        //self.bounds.size
        //CGSize(width: self.bounds.width, height: self.bounds.height - 200
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        //y: self.bounds.origin.y - 60
        drawHierarchy(in: CGRect(x: rect.origin.x, y: rect.origin.y, width: self.bounds.width, height: self.bounds.height)//self.bounds
            , afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = image, shouldSave {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        }
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    //漸層
    func setGradualColor(firstColor:UIColor,secondColor:UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    func setConicGradualColor(firstColor:UIColor,secondColor:UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    //view的 viewcontroller
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    //=====  Badge  =====
    
    
    static func customEmptyView() -> UIView {
        let newView = self.init(frame: CGRect.zero)
        newView.backgroundColor = UIColor.clear
        return newView
    }
    func takeCustomQRCodeScreenshot(shouldSave: Bool = true) -> UIImage {
        
        // Begin context
        //self.bounds.size
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.width, height: self.bounds.height - 200), false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: CGRect(x: 0.0, y: self.bounds.origin.y - 60, width: self.bounds.width, height: self.bounds.height)//self.bounds
            , afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = image, shouldSave {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        }
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    //MARK : Easy Get Frame Property
    var x:CGFloat {
        return self.frame.origin.x;
    }
    
    var y:CGFloat {
        return self.frame.origin.y;
    }
    
    var width:CGFloat {
        return self.frame.size.width;
    }
    
    var height:CGFloat {
        return self.frame.size.height;
    }
    
    //MARK:ViewTouch Delegate Function
    var viewTouchDelegate:ViewTouchDelegate?
    {
        get{
            return objc_getAssociatedObject(self, &ViewTouchAssociatedKeys.viewTouchDelegate) as? ViewTouchDelegate;
        }
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &ViewTouchAssociatedKeys.viewTouchDelegate, newValue as ViewTouchDelegate?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    //MARK:Private Struct
    private struct ViewTouchAssociatedKeys
    {
        static var viewTouchDelegate = "viewTouchDelegate";
    }
    
    //MARK:Public Function
    @objc func triggerDelegate_buttonTouch(_ target:UIButton) -> Void
    {
        if let delegate:ViewTouchDelegate = self.viewTouchDelegate{
            if(delegate.responds(to: #selector(viewTouchDelegate?.viewButtonToch(_:withTarget:)))){
                delegate.viewButtonToch!(self, withTarget: target);
            }
        }
    }
}

@objc public protocol ViewTouchDelegate : NSObjectProtocol
{
    @objc optional func viewButtonToch(_ view:UIView, withTarget target:UIButton) -> Void;
}



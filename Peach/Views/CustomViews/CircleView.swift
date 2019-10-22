//
//  CircleView.swift
//  Peach
//
//  Created by Daniel on 17/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CircleView: IBInspectableView {
    
    //MARK:- Property
    @IBInspectable var totalProgressTime: CGFloat = 30
    @IBInspectable var lineWidth: CGFloat = 0 {
        didSet {
            progressLayer.lineWidth = lineWidth
            updateCirclePath()
        }
    }
    
    private let progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    //MARK:- Initialize
    init(frame: CGRect, lineWidth: CGFloat) {
        super.init(frame: frame)
        self.lineWidth = lineWidth
        self.buildCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.buildCircle()
    }
    
    //MARK:- Public Function
    func startProgress(initialTime: CGFloat) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = CFTimeInterval(totalProgressTime - initialTime)
        pathAnimation.fromValue = NSNumber(value: 0)
        pathAnimation.toValue = NSNumber(value: 1)
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pathAnimation.isRemovedOnCompletion = false
        progressLayer.strokeEnd = 1
        progressLayer.add(pathAnimation, forKey: "strokeEnd")
    }
    
    func stopProgress() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0
        progressLayer.timeOffset = pausedTime
    }
    
    func resetProgress() {
        progressLayer.strokeEnd = 0
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.removeAllAnimations()
    }
    
    //MARK:- Private Function
    private func buildCircle() {
        updateCirclePath()
        
        //進度條
        progressLayer.frame = self.bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
//        self.layer.addSublayer(progressLayer)
        
        //漸變色layer
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.75)
        gradientLayer.colors = [UIColor.customColor(.color_text_1).cgColor, UIColor.customColor(.pink_1).cgColor]
        gradientLayer.mask = progressLayer
        self.layer.addSublayer(gradientLayer)
    }
    
    private func updateCirclePath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = (min(self.bounds.size.width,self.bounds.size.height) - lineWidth) / 2
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi / 2 * 3), clockwise: true)
        progressLayer.path = path.cgPath
    }
}

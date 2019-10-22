//
//  CoreCollectionViewCell.swift
//  Peach
//
//  Created by dean on 2019/8/12.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CoreCollectionViewCell: UICollectionViewCell,CellPressible {
    
    var item: RowItemProtocol?
    
    //false 表示要有動畫
    var disabledHighlightedAnimation = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    //=====  init 用  =====
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    //=====  點擊事件  =====
    func addClickListener(view:UIView) {
        view.addTapGesture(tapNumber: 1, target: self, action: #selector(didClickView(_:)))
    }
    var cellPressed: (() -> (Void))?
    
    
    @objc func didClickView(_ sender: Any) {
        cellPressed?()
        
    }
    
    //MARK: - Animation
    func resetTransform() {
        transform = .identity
    }
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.6) {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } else {
                self.transform = .identity
            }
        }
    }
    
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        let animationOptions: UIView.AnimationOptions = GlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard
            ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: GlobalConstants.cardHighlightedFactor, y: GlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}

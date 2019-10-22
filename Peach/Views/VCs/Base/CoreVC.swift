//
//  CoreVC.swift
//  Peach
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import UIKit
import Lottie

protocol ViewControllerSetUpProtocol {
    func setVMAndRouter()
    func setUpUIs()
    func updateUIFrame()
}


class CoreVC: UIViewController, ViewControllerSetUpProtocol {
    
    var viewModel:BaseVM?
    var router:Router?
    var loadingView:AnimationView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setVMAndRouter()
        setUpUIs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUIFrame()
    }
    
    func setVMAndRouter() {}
    
    func setUpUIs() {
        self.configureLoadingView()
    }
    
    func updateUIFrame() {}
    
    func hideLoadingView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            //放大至原大小
            self.loadingView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (complete) in
            self.loadingView.isHidden = true
        }
    }
    
    func showLoadingView() {
        self.loadingView.transform = CGAffineTransform.identity
        self.loadingView.isHidden = false
        self.loadingView.play()
        self.view.bringSubviewToFront(self.loadingView)
    }
    
    private func configureLoadingView() {
        self.loadingView = AnimationView()
        let animation = Animation.named("loading")
        self.loadingView.animation = animation
        self.loadingView.loopMode = .loop
        self.view.addSubview(self.loadingView)
        self.loadingView.isHidden = true
        
        DispatchQueue.main.async {
            let sizeLoadingView:CGSize = CGSize(width: 100.0, height: 100.0)
            self.loadingView.frame = CGRect(x: (self.view.width - sizeLoadingView.width) / 2.0, y: (self.view.height - sizeLoadingView.height) / 2.0, width: sizeLoadingView.width, height: sizeLoadingView.height)
        }
    }
    
    //=====  點擊事件  =====
    func addClickListener(view:UIView) {
        view.addTapGesture(tapNumber: 1, target: self, action: #selector(didClickView(_:)))
    }
    
    var viewPressed: (() -> (Void))?
    @objc func didClickView(_ sender: Any) {
        viewPressed?()
    }
}

//MARK: -一些預設可用的func
extension CoreVC {
    
}

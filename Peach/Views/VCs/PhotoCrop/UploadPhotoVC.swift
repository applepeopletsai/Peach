//
//  UploadPhotoVC.swift
//  Peach
//
//  Created by dean on 2019/10/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Foundation

class UploadPhotoVC: CoreCollectionVC {
    
    @IBOutlet weak var topContentView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var userInputTextView: UITextView!
    
    
    @IBOutlet weak var shouldLockSwitch: UISwitch!
    
    var shouldShowCellLabel = false
    
    var placeholderLabel : UILabel!
    
    var images:Array<UIImage>? = [UIImage(named: "Einstein")!,UIImage(named: "shark")!,UIImage(named: "Steve-Jobs")!,UIImage(named: "Tim-Cook")!,UIImage(named: "shark2")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = true
        
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        shouldLockSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        addTextViewPlaceHolder()
        hideKeyboard()
        //Nav
        self.navigationItem.title = "upLoad_Title".localized
        addImageBackBtn()
//        self.addCustomBackBtn()
        self.addCustomRightNaviItem(with: "upLoad_upLoad".localized) {
            self.upLoadPhotos()
        }
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "上傳", style: .plain, target: self, action: #selector(upLoadPhotos))
//        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        addToolBarUptoKeyboard()
    }
    
    override func setVMAndRouter() {
        super.setVMAndRouter()
        
        DispatchQueue.main.async {
            let vm = UploadPhotoVM()
            self.viewModel = vm
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            if self.images?.count ?? 0 > 0 {
                layout.itemSize = CGSize(width: self.topContentView.bounds.width, height: self.view.bounds.width)
//                if self.images?.count ?? 0 == 1 {
//                    layout.itemSize = CGSize(width: self.topContentView.bounds.width, height: self.topContentView.bounds.width)
//                } else {
//                    layout.itemSize = CGSize(width: self.topContentView.bounds.width - 20, height: self.topContentView.bounds.width)
//                }
            }
            if self.images?.count ?? 0 > 1 {
                self.shouldShowCellLabel = true
            }
//            let images = [UIImage(named: "Einstein"),UIImage(named: "shark"),UIImage(named: "Steve-Jobs"),UIImage(named: "Tim-Cook"),UIImage(named: "shark2")]
            
            vm.dataConverter(data: self.images)
            
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            self.setCollectionView(collectionView: self.collectionView, layout: layout)
            self.collectionView.isPagingEnabled = true
            self.collectionView.showsHorizontalScrollIndicator = false
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        self.navigationController?.navigationBar.isTranslucent = false
            if let userInfo = notification.userInfo {
//                guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
//                let keyboardFrame = keyboardSize.cgRectValue
//                if self.view.frame.origin.y == 0{
//                    self.view.frame.origin.y -= keyboardFrame.height
//                }
                let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let duration: Double = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

                UIView.animate(withDuration: duration, animations: { () -> Void in
                    var frame = self.view.frame
                    frame.origin.y = keyboardFrame.minY - self.view.frame.height
                    self.view.frame = frame
                })
            }
        }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.navigationController?.navigationBar.isTranslucent = true
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
        
    }
    func addTextViewPlaceHolder() {
        userInputTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "加入相片說明........"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (userInputTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        userInputTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (userInputTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !userInputTextView.text.isEmpty
    }
    func addToolBarUptoKeyboard() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let done =  UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneWithNumberPad))
        done.tintColor = UIColor.black
        
        numberToolbar.items = [
//        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        done]
//        UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        userInputTextView.inputAccessoryView = numberToolbar
    }
    
    @objc func doneWithNumberPad() {
        //Done with number pad
        self.userInputTextView.resignFirstResponder()
    }
    
    @IBAction func shouldLockSwitchAction(_ sender: Any) {
        
    }
    @objc private func upLoadPhotos() {
        
    }
}



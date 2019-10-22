//
//  CropperViewController.swift
//  Peach
//
//  Created by dean on 2019/10/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CropperViewController: CoreVC {
    
    @IBOutlet weak var topContentView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.setRound()
            iconImageView.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var describeLabel: UILabel!
    
    
    var scrollView: UIScrollView?
    var imageView: UIImageView?
    
    var userImage:UIImage?
    
    var imageAfterCropped:UIImage?
    //Corrper lines
    var firstVLine:UIView?
    var secondVLine: UIView?
    var firstHLine:UIView?
    var secondHLine:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.userImage != nil {
            
            self.setTopScrollView(image: self.userImage)
            imageAfterCropped = self.userImage
        } else {
            setTopScrollView(image: UIImage(named: "Einstein"))
            imageAfterCropped = UIImage(named: "Einstein")
        }
//        setTopScrollView(image: UIImage(named: "Einstein"))
        self.title = "crop_Title".localized
        //Nav
        addImageBackBtn()
//        self.addCustomBackBtn()
        self.addCustomRightNaviItem(with: "crop_NextStep".localized) {
            self.nextVC()
        }
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextVC))
//        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.edgesForExtendedLayout = UIRectEdge.init()
    }
    override func setVMAndRouter() {
        super.setVMAndRouter()
        self.router = UploadPostRouter()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()

//    }
    func setTopScrollView(image:UIImage?) {
        imageView = UIImageView(image: image)
        DispatchQueue.main.async {
            self.imageView?.frame = self.topContentView.bounds
            self.imageView?.contentMode = .scaleAspectFill
            self.scrollView = UIScrollView(frame: self.topContentView.bounds)
            self.scrollView?.showsVerticalScrollIndicator = false
            self.scrollView?.showsHorizontalScrollIndicator = false
            self.scrollView?.contentSize = self.imageView?.bounds.size ?? CGSize(width: 30, height: 30)
            self.scrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.scrollView?.delegate = self
            self.scrollView?.minimumZoomScale = 1
            self.scrollView?.maximumZoomScale = 4.0
            self.scrollView?.zoomScale = 1.0
            self.scrollView?.bounces = false
            self.scrollView?.frame = self.topContentView.frame
            self.scrollView?.decelerationRate = .fast
            self.scrollView?.center = self.topContentView.center
            self.scrollView?.addSubview(self.imageView ?? UIImageView())
            self.topContentView.addSubview(self.scrollView ?? UIScrollView())
            self.addCropper()
        }
        
    }
    
    func addCropper() {

        
        let contentWidth = self.topContentView.frame.size.width
        let contentHeight = self.topContentView.frame.size.height

        let squareWidth = contentWidth / 3
        let squareHeight = contentHeight / 3

        firstVLine = UIView(frame: CGRect(x: squareWidth, y: 0, width: 1, height: contentHeight))
        secondVLine = UIView(frame: CGRect(x: squareWidth * 2, y: 0, width: 1, height: contentHeight))

        firstHLine = UIView(frame: CGRect(x: 0, y: squareHeight, width: contentWidth, height: 1))
        secondHLine = UIView(frame: CGRect(x: 0, y: squareHeight * 2, width: contentWidth, height: 1))

        firstVLine?.backgroundColor = UIColor.white
        secondVLine?.backgroundColor = UIColor.white
        firstHLine?.backgroundColor = UIColor.white
        secondHLine?.backgroundColor = UIColor.white

        self.view.addSubview(firstVLine ?? UIView())
        self.view.addSubview(secondVLine ?? UIView())
        self.view.addSubview(firstHLine ?? UIView())
        self.view.addSubview(secondHLine ?? UIView())

        self.imageView?.superview?.superview?.bringSubviewToFront(firstVLine ?? UIView())
        self.imageView?.superview?.superview?.bringSubviewToFront(secondVLine ?? UIView())
        self.imageView?.superview?.superview?.bringSubviewToFront(firstHLine ?? UIView())
        self.imageView?.superview?.superview?.bringSubviewToFront(firstVLine ?? UIView())
        
        let topBorderWidth:CGFloat = 1.5
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBorderWidth))
        let leftView = UIView(frame: CGRect(x: 0, y: topBorderWidth, width: topBorderWidth, height: self.topContentView.frame.height))
        let rightView = UIView(frame: CGRect(x: self.view.frame.width - topBorderWidth, y: 0, width: topBorderWidth, height: self.topContentView.frame.height))
        let bottomView = UIView(frame: CGRect(x: 0, y: self.topContentView.frame.height, width: self.view.frame.width, height: topBorderWidth))
        
        topView.backgroundColor = UIColor.customColor(.color_text_5)
        leftView.backgroundColor = UIColor.customColor(.color_text_5)
        rightView.backgroundColor = UIColor.customColor(.color_text_5)
        bottomView.backgroundColor = UIColor.customColor(.color_text_5)
        self.view.addSubview(topView)
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        self.view.addSubview(bottomView)
        
        self.imageView?.superview?.superview?.bringSubviewToFront(topView)
        self.imageView?.superview?.superview?.bringSubviewToFront(leftView)
        self.imageView?.superview?.superview?.bringSubviewToFront(rightView)
        self.imageView?.superview?.superview?.bringSubviewToFront(bottomView)
    }
    private func adjustCropperView() {
        DispatchQueue.main.async {
            let contentWidth = self.topContentView.frame.size.width
            let contentHeight = self.topContentView.frame.size.height
            print(self.topContentView.frame.origin)
            let squareWidth = contentWidth / 3
            let squareHeight = contentHeight / 3
            
            self.firstVLine = UIView(frame: CGRect(x: squareWidth, y: self.topContentView.frame.origin.y, width: 1, height: contentHeight))
            self.secondVLine = UIView(frame: CGRect(x: squareWidth * 2, y: self.topContentView.frame.origin.y, width: 1, height: contentHeight))
            
            self.firstHLine = UIView(frame: CGRect(x: self.topContentView.frame.origin.x, y: squareHeight, width: contentWidth, height: 1))
            self.secondHLine = UIView(frame: CGRect(x: self.topContentView.frame.origin.x, y: squareHeight * 2, width: contentWidth, height: 1))
        }
        
    }
    @IBAction func btnAction(_ sender: Any) {
        
//        crop()
        guard let image = snapshot() else {
            return
        }
        self.imageAfterCropped = image
        
        
    }
    func snapshot() -> UIImage?
    {
        
        // Begin context
        //self.bounds.size
        UIGraphicsBeginImageContextWithOptions(self.topContentView.frame.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        self.topContentView.drawHierarchy(in: CGRect(x: 0.0, y: self.topContentView.bounds.origin.y, width: self.topContentView.bounds.width, height: self.topContentView.bounds.height), afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
        
    }
    func crop() {
        let scale:CGFloat = 1/(scrollView?.zoomScale ?? 1)
        let x:CGFloat = (scrollView?.contentOffset.x ?? 0) * scale
        let y:CGFloat = scrollView?.contentOffset.y ?? 0 * scale
        let width:CGFloat = scrollView?.frame.size.width ?? 0 * scale
        let height:CGFloat = scrollView?.frame.size.height ?? 0 * scale
        let croppedCGImage = imageView?.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        print(croppedImage)
        self.imageView?.image = croppedImage
        print(croppedImage)
//        setImageToCrop(image: croppedImage)
    }
    //Nav
    @objc func nextVC() {
            
        self.router?.route(to: UploadPostRouterID.upLoadPhoto.rawValue, from: self, parameters: [self.imageAfterCropped])
    }
}
extension CropperViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        guard let image = snapshot() else {
//            return
//        }
//        self.imageAfterCropped = image
//    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let image = snapshot() else {
            return
        }
        self.imageAfterCropped = image
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let image = snapshot() else {
            return
        }
        self.imageAfterCropped = image
    }

}

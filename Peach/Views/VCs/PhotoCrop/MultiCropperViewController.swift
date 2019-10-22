//
//  MultiCropperViewController.swift
//  Peach
//
//  Created by dean on 2019/10/9.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Foundation

class MultiCropperViewController: CoreCollectionVC {
    
    
    @IBOutlet weak var topContentView: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    var originalImages:Array<UIImage>?// = [UIImage(named: "Einstein")!,UIImage(named: "shark")!,UIImage(named: "Steve-Jobs")!,UIImage(named: "Tim-Cook")!,UIImage(named: "shark2")!]
    
    var imageSacles:Array<CGFloat> = []//記錄圖片縮放
    
    var changedImagePoint:Array<CGPoint> = []//記錄圖片位置
    
    var croppedImages:Array<UIImage> = []//裁切後的圖片
    
    var selectedIndex = 0//目前選擇哪一個cell
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        DispatchQueue.main.async {
//            setTopScrollView(image: UIImage(named: "Einstein"))
//        }
        
        //CollectionView
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        self.title = "crop_Title".localized
        //Nav
        addImageBackBtn()
        self.addCustomRightNaviItem(with: "crop_NextStep".localized) {
            self.nextVC()
        }
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextVC))
//        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func setVMAndRouter() {
        super.setVMAndRouter()
        self.router = UploadPostRouter()
        DispatchQueue.main.async {
            let vm = MultiCropperVM()
            self.viewModel = vm
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            if self.originalImages?.count ?? 0 > 0 {
                layout.itemSize = CGSize(width: self.collectionView.bounds.height / 2, height: self.collectionView.bounds.height / 2)
                self.setTopScrollView(image: self.originalImages?.first)
            }
            
            
            
            vm.dataConverter(data: self.originalImages)
            
            self.setDefaultImageScales()//設定Default Scale為1
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
            self.setCollectionView(collectionView: self.collectionView, layout: layout)
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isTranslucent = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Toast.show(message: "My message", font: UIFont.systemFont(ofSize: 20), backgroundColor: UIColor(red: CGFloat(62/255.0), green: CGFloat(224/255.0), blue: CGFloat(177/255.0), alpha: 0.7), controller: self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.once(token: "SelectFirstItemOnce") {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.layoutIfNeeded()
                
            }
            
        }
        DispatchQueue.main.after(time: .now() + 0.3) {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
            self.collectionView(self.collectionView, didSelectItemAt: selectedIndexPath)
//            Toast.show(message: "My message", controller: self)
            
            
        }
        
    }
    func setTopScrollView(image:UIImage?) {
        imageView = UIImageView(image: image)
        DispatchQueue.main.async {
            self.imageView?.frame = self.topContentView.bounds
        }
//        imageView.frame = topContentView.bounds
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.addBorder(edge: .all, color: UIColor.customColor(.color_text_5), thickness: 1.5)
        
        scrollView = UIScrollView(frame: topContentView.bounds)
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
//        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.frame = topContentView.frame
        scrollView.center = topContentView.center
        
        
        
        scrollView.addSubview(imageView)
        topContentView.addSubview(scrollView)
        addCropper()
    }
    func setDefaultImageScales() {
        if self.originalImages?.count ?? 0 > 0 {
            for _ in 0...(originalImages?.count ?? 1) - 1 {
                self.imageSacles.append(1)
                self.changedImagePoint.append(CGPoint(x: 0, y: 0))
                
            }
            for image in originalImages ?? [] {
                self.croppedImages.append(image)
            }
        }
        
    }
    func addCropper() {
        let contentWidth = self.topContentView.frame.size.width
        let contentHeight = self.topContentView.frame.size.height
        
        let squareWidth = contentWidth / 3
        let squareHeight = contentHeight / 3
        
        let firstVLine = UIView(frame: CGRect(x: squareWidth, y: 0, width: 1, height: contentHeight))
        let secondVLine = UIView(frame: CGRect(x: squareWidth * 2, y: 0, width: 1, height: contentHeight))
        
        let firstHLine = UIView(frame: CGRect(x: 0, y: squareHeight, width: contentWidth, height: 1))
        let secondHLine = UIView(frame: CGRect(x: 0, y: squareHeight * 2, width: contentWidth, height: 1))
        
        firstVLine.backgroundColor = UIColor.white
        secondVLine.backgroundColor = UIColor.white
        firstHLine.backgroundColor = UIColor.white
        secondHLine.backgroundColor = UIColor.white
        
        self.view.addSubview(firstVLine)
        self.view.addSubview(secondVLine)
        self.view.addSubview(firstHLine)
        self.view.addSubview(secondHLine)
        
        self.imageView.superview?.superview?.bringSubviewToFront(firstVLine)
        self.imageView.superview?.superview?.bringSubviewToFront(secondVLine)
        self.imageView.superview?.superview?.bringSubviewToFront(firstHLine)
        self.imageView.superview?.superview?.bringSubviewToFront(firstVLine)
        
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
        
        self.imageView.superview?.superview?.bringSubviewToFront(topView)
        self.imageView.superview?.superview?.bringSubviewToFront(leftView)
        self.imageView.superview?.superview?.bringSubviewToFront(rightView)
        self.imageView.superview?.superview?.bringSubviewToFront(bottomView)
        
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
//            print(image)
//            let xx = UIImageView(image: image)
//            print(xx)
            return image!
        }
        return UIImage()
        
    }
    func crop() {
            let scale:CGFloat = 1/scrollView.zoomScale
            let x:CGFloat = scrollView.contentOffset.x * scale
            let y:CGFloat = scrollView.contentOffset.y * scale
            let width:CGFloat = scrollView.frame.size.width * scale
            let height:CGFloat = scrollView.frame.size.height * scale
            let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
            let croppedImage = UIImage(cgImage: croppedCGImage!)
            let xx = UIImageView(image: croppedImage)
            print(croppedImage)
//            self.imageView.image = croppedImage
//            print(croppedImage)
    //        setImageToCrop(image: croppedImage)
        }
    func finalCrop() {
        
        for (index,scale) in imageSacles.enumerated() {
            let finalScale:CGFloat = 1/scale
            let x:CGFloat = changedImagePoint[index].x * finalScale//scrollView.contentOffset.x * finalScale
            let y:CGFloat = changedImagePoint[index].y * finalScale//scrollView.contentOffset.y * finalScale
            let width:CGFloat = scrollView.frame.size.width * finalScale
            let height:CGFloat = scrollView.frame.size.height * finalScale
            guard let image = originalImages?[index] else {return}
            let croppedCGImage = image.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
            let croppedImage = UIImage(cgImage: croppedCGImage!)
            let xx = UIImageView(image: croppedImage)
            print(croppedImage)
        }
    }
    func multiCropper() {
        //最後再重設一次，免得user直接按下下一步
        if let croppedImage = self.snapshot() {
            self.croppedImages[self.selectedIndex] = croppedImage
        }
        if croppedImages.count > 0 {
            self.router?.route(to: UploadPostRouterID.upLoadPhoto.rawValue, from: self, parameters: croppedImages)
        }
        //倒出全部image For Debug
        for image in croppedImages {
            let imahgev = UIImageView(image: image)
            print(image)
            print(imahgev)
        }
    }
    //Nav
    @objc func nextVC() {
//        finalCrop()
        multiCropper()
    }
}

extension MultiCropperViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scale = scrollView.zoomScale
//        print(scrollView.contentInset)
        
        imageSacles[selectedIndex] = scale
        
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.y > 0 {
            changedImagePoint[selectedIndex] = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
//            print("x:\(scrollView.contentOffset.x) y:\(scrollView.contentOffset.y)")
        }
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.y > 0 {
            changedImagePoint[selectedIndex] = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
        }
//        changedImagePoint[selectedIndex] = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
//        print("x:\(scrollView.contentOffset.x) y:\(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.y > 0 {
            changedImagePoint[selectedIndex] = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
        }
        
    }
}

extension MultiCropperViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        super.collectionView(collectionView, cellForItemAt: indexPath)
        if let item = self.viewModel?.items?[indexPath.section].rows[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(with: item.collectionViewCell ?? UICollectionViewCell.self, for: indexPath)
            
            if cell.isKind(of: CoreCollectionViewCell.self) {
                let cell = cell as? ImageOnlyCollectionViewCell
                cell?.item = item
                cell?.shouldShowNumberLabel(shouldShow:false , number: "\(indexPath.row)",totalCount:"\(self.originalImages?.count)")
//                cell?.layer.borderColor = UIColor.red.cgColor
//                cell?.layer.borderWidth = 3
//                if indexPath.row == self.selectedIndex {
//                    cell?.layer.addBorder(edge: .all, color: UIColor.customColor(.color_text_5), thickness: 2.5)
//                } else {
//                    cell?.layer.addBorder(edge: .all, color: UIColor.clear, thickness: 0)
//                }
//                collectionView.reloadData()
            }
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let value = viewModel?.items?[indexPath.section].rows[indexPath.row].value as? [String : Any] {
            
        }
        
        DispatchQueue.main.async {
            //Crop Image First
            if let croppedImage = self.snapshot() {
                self.croppedImages[self.selectedIndex] = croppedImage
            }
            
            self.selectedIndex = indexPath.row
            let cell = collectionView.cellForItem(at: indexPath) as? ImageOnlyCollectionViewCell
            
            
            let scale = self.imageSacles[indexPath.row]
            
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 4.0
              
            let changedPoint = CGPoint(x: self.changedImagePoint[indexPath.row].x, y: self.changedImagePoint[indexPath.row].y)
            
//            self.scrollView.contentOffset = changedPoint
            print(changedPoint)
            self.imageView.image = cell?.avaterImageView.image
            self.scrollView.zoomScale = scale ?? 1
            self.scrollView.setContentOffset(changedPoint, animated: false)
            
            if indexPath.row == self.selectedIndex {
                cell?.layer.addBorder(edge: .all, color: UIColor.customColor(.color_text_5), thickness: 2.5)
            } else {
                cell?.layer.addBorder(edge: .all, color: UIColor.clear, thickness: 0)
            }
//            collectionView.reloadData()
        }
        
        
        
        
        
        
    }
}

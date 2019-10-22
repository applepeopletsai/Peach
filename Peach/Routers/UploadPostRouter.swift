//
//  UploadPostRouter.swift
//  Peach
//
//  Created by Daniel on 9/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import AVFoundation

enum UploadPostRouterID:String {
    case selectAsset            //選擇照片/影片
    case takePhoto              //拍照
    case video                  //錄影
    case selectVideoImage       //選擇封面
    case photoCrop
    case photosCrop
    case upLoadPhoto
}

class UploadPostRouter: Router {
    
    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        switch routeID {
        case UploadPostRouterID.selectAsset.rawValue:
            let vc = SelectPhotosViewController(nibName: String(describing: SelectPhotosViewController.self), bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            if let currentNaviVC = context as? UINavigationController {
                currentNaviVC.pushViewController(vc, animated: false)
            }
            break
        case UploadPostRouterID.takePhoto.rawValue:
            let vc = CameraViewController(nibName: String(describing: CameraViewController.self), bundle: nil, type: .photo)
            context.navigationController?.pushViewController(vc, animated: true)
            break
        case UploadPostRouterID.video.rawValue:
        let vc = CameraViewController(nibName: String(describing: CameraViewController.self), bundle: nil, type: .video)
        context.navigationController?.pushViewController(vc, animated: true)
            break
        case UploadPostRouterID.selectVideoImage.rawValue:
            guard let dic: [String:Any] = parameters as? [String:Any], let video = dic["video"] as? AVAsset, let images = dic["images"] as? [UIImage] else { return }
            let vc = SelectCoverViewController(nibName: String(describing: SelectCoverViewController.self), bundle: nil, video: video, images: images)
            context.navigationController?.pushViewController(vc, animated: true)
            break
        case UploadPostRouterID.photoCrop.rawValue:
            let vc = CropperViewController(nibName: "CropperViewController", bundle: nil)
            if let image = parameters as? UIImage {
                vc.userImage = image
            }
            context.navigationController?.pushViewController(vc, animated: true)
        case UploadPostRouterID.photosCrop.rawValue:
            let vc = MultiCropperViewController(nibName: "MultiCropperViewController", bundle: nil)
            if let images = parameters as? [UIImage] {
                vc.originalImages = images
            }
            context.navigationController?.pushViewController(vc, animated: true)
        case UploadPostRouterID.upLoadPhoto.rawValue:
            let vc = UploadPhotoVC(nibName: "UploadPhotoVC", bundle: nil)
            if let images = parameters as? [UIImage] {
                vc.images = images
            }
            context.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}

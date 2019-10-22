//
//  PhotoHelper.swift
//  Peach
//
//  Created by Daniel on 2/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

public protocol PhotoHelperDelegate: NSObjectProtocol {
    func didGetImage(_ image: UIImage)
    func didCancel()
}

public class PhotoHelper: NSObject {
    
    //MARK: - Property
    static let shared = PhotoHelper()
    private let pickerVC = UIImagePickerController()
    private weak var delegate: PhotoHelperDelegate?
    
    //MARK: - Initialize
    private override init() {
        super.init()
        pickerVC.modalPresentationStyle = .fullScreen
        pickerVC.delegate = self
    }
    
    //MARK: - Public Function
    public func pickPhoto(with delegate: PhotoHelperDelegate) {
        self.delegate = delegate
        self.showImagePicker(with: .camera)
    }
    
    public func selectPhotoFromPhotoLibrary(with delegate: PhotoHelperDelegate) {
        self.delegate = delegate
        self.showImagePicker(with: .photoLibrary)
    }
    
    public func obtainPermission(forMediaSourceType sourceType: UIImagePickerController.SourceType, success: ActionHandler?, failure: ActionHandler?) {
        
        switch sourceType {
        case .photoLibrary, .savedPhotosAlbum:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    DispatchQueue.main.async { success?() }
                    break
                default:
                    DispatchQueue.main.async { failure?() }
                    break
                }
            }
            break
        case .camera:
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.main.async { success?() }
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    DispatchQueue.main.async {
                        if granted {
                            success?()
                        } else {
                            failure?()
                        }
                    }
                })
                break
            default:
                DispatchQueue.main.async { failure?() }
                break
            }
            break
        @unknown default:
            DispatchQueue.main.async { failure?() }
            break
        }
    }
    
    //MARK: - Private Function
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        pickerVC.sourceType = sourceType
        
        self.obtainPermission(forMediaSourceType: sourceType, success: {
            self.topViewController().present(self.pickerVC, animated: true, completion: nil)
        }, failure: {
            let title = (sourceType == .camera) ? "尚未開啟相機權限" : "尚未開啟相簿權限"
            let message = (sourceType == .camera) ? "請至設定開啟相機權限" : "請至設定開啟相簿權限"
            self.topViewController().showDefaultAlert(title: title, message: message, okBtnTitle: "前往設定", cancelBtnTitle: "取消", complention: {
                guard let url = URL(string: "\(UIApplication.openSettingsURLString)\(Bundle.main.bundleIdentifier ?? "")") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        })
    }
}

extension PhotoHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /*
     從相簿選取照片會有錯誤訊息：errors encountered while discovering extensions: Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled}
     暫無解決方法
     參考：https://forums.developer.apple.com/thread/82105
     */
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String
        if mediaType == "public.image" {
            
            guard let originImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            let success = {
                self.delegate?.didGetImage(originImage)
                picker.dismiss(animated: true, completion: nil)
            }
            
            if picker.sourceType == .camera {
                self.obtainPermission(forMediaSourceType: .savedPhotosAlbum, success: {
                    UIImageWriteToSavedPhotosAlbum(originImage, self,  #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    success()
                }, failure: nil)
            } else {
                success()
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.didCancel()
        self.topViewController().dismissVC()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("照片存至相簿失敗：\(error)")
        } else {
            print("照片存至相簿成功")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

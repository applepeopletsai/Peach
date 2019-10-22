//
//  CameraViewController.swift
//  Peach
//
//  Created by Daniel on 9/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: CoreVC {
    
    //MARK:- Property
    @IBOutlet private weak var previewView: PreviewView!
    @IBOutlet private weak var permissionView: UIView!
    @IBOutlet private weak var capturePhotoBgView: CircleView!
    @IBOutlet private weak var captureButton: UIButton!
    
    var type: AssetType = .photo
    private var focusView: UIView!
    private var timer: Timer?
    
    //MARK:- Initialize
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, type: AssetType) {
        self.type = type
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageBackBtn()
        self.configureNavigationBar()
        self.configureFocusView()
        
        self.configureCamera()
        self.resetCaptureButton()
    }
    
    override func setVMAndRouter() {
        super.setVMAndRouter()
        self.viewModel = CameraVM(type: self.type)
        self.router = UploadPostRouter()
    }
    
    deinit {
        if timer != nil { timer?.invalidate() }
    }
    
    //MARK:- Private Function
    private func configureNavigationBar() {
        self.navigationItem.title = (self.type == .photo) ? "photo_7".localized : "photo_13".localized
        self.addCustomBackNaviItem(with: "naviBar_2".localized)
    }
    
    private func configureFocusView() {
        self.focusView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.focusView.backgroundColor = .clear
        self.focusView.layer.borderColor = UIColor.customColor(.color_text_6).cgColor
        self.focusView.layer.borderWidth = 1
        self.focusView.isHidden = true
        self.focusView.alpha = 0
        self.previewView.addSubview(focusView)
    }
    
    private func configurePreviewView() {
        guard let vm = self.viewModel as? CameraVM else { return }
        self.previewView.session = vm.returnCaptureSession()
//        let windowOrientation = UIDevice.current.orientation
//        self.previewView.videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: windowOrientation.rawValue) ?? .portrait
        self.previewView.videoPreviewLayer.connection?.videoOrientation = .portrait
    }
    
    private func configureCamera() {
        PhotoHelper.shared.obtainPermission(forMediaSourceType: .camera, success: {
            self.capturePhotoBgView.isHidden = false
            self.captureButton.isHidden = false
            
            guard let vm = self.viewModel as? CameraVM else { return }
            vm.prepareCamera(completionHandler: { error in
                if error == nil {
                    self.configurePreviewView()
                    vm.startRunningCamera()
                } else {
                    print(error!)
                }
            })
        }, failure: {
            self.permissionView.isHidden = false
        })
    }
    
    private func resetCaptureButton() {
        if self.type == .video {
            self.captureButton.isEnabled = true
            self.captureButton.setTitle("30s", for: .normal)
        }
    }
    
    private func resetCirlceProgress() {
        if self.type == .video {
            self.capturePhotoBgView.resetProgress()
        }
    }
    
    private func showFocusView(_ gestureRecognizer: UITapGestureRecognizer) {
        let center = gestureRecognizer.location(in: self.previewView)
        self.focusView.center = center
        self.focusView.isHidden = false
        self.focusView.alpha = 1
        self.focusView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.focusView.transform = .identity
        }, completion: { _ in
            self.hideFocusView()
        })
    }
    
    private func hideFocusView() {
        self.focusView.alpha = 0
        self.focusView.isHidden = true
    }
    
    //MARK:- Action Handler
    @IBAction fileprivate func permissionButtonPress(_ sender: UIButton) {
        self.gotoSetting()
    }
    
    @IBAction private func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let vm = self.viewModel as? CameraVM else { return }
        let devicePoint = self.previewView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: gestureRecognizer.location(in: gestureRecognizer.view))
        vm.focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
        self.showFocusView(gestureRecognizer)
    }
    
    @IBAction private func captureButtonPress(_ sender: UIButton) {
        guard let vm = self.viewModel as? CameraVM else { return }

        weak var weakSelf = self
        func refreshUIAfterFinishCapture() {
            weakSelf?.removeLeftNaviItem()
            weakSelf?.addCustomLeftNaviItem(with: "photo_8".localized, actionHandler: {
                weakSelf?.resetCaptureButton()
                weakSelf?.resetCirlceProgress()
                weakSelf?.removeLeftNaviItem()
                weakSelf?.removeRightNaviItem()
                weakSelf?.addCustomBackNaviItem(with: "naviBar_2".localized)
                vm.startRunningCamera()
            })
        }
        
        func stopRecording() {
            weakSelf?.timer?.invalidate()
            weakSelf?.captureButton.isEnabled = false
            
            vm.stopRecording(completion: { [weak weakSelf] video, error in
                guard let video = video else {
                    print(error ?? "video recording error")
                    return
                }

                weakSelf?.addCustomRightNaviItem(actionHandler: {
                    //下一步
                    VideoHelper.shared.fetchVideoImage(video: video, completion: { images in
                        weakSelf?.router?.route(to: UploadPostRouterID.selectVideoImage.rawValue, from: weakSelf!, parameters: ["video":video,"images":images])
                    })
                })
                
                refreshUIAfterFinishCapture()
                vm.stopRunningCamera()
            })
        }
        
        if self.type == .photo {
            vm.captureImage(completion: { [weak self] image, error in
                guard let image = image else {
                    print(error ?? "Image capture error")
                    return
                }
                
                self?.addCustomRightNaviItem(actionHandler: {
                    //下一步
                    self?.router?.route(to: UploadPostRouterID.photoCrop.rawValue, from: self ?? UIViewController(), parameters: image)
                })
                
                refreshUIAfterFinishCapture()
                vm.stopRunningCamera()
            })
        } else {
            if !vm.isRecording() {
                vm.startRecording(didStartHandler: { [weak self] duration in
                    self?.capturePhotoBgView.startProgress(initialTime: vm.recordedDuration())
                    
                    self?.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                        if vm.recordedDuration() >= 30 { stopRecording() }
                        self?.captureButton.setTitle("\(Int(30 - vm.recordedDuration()))s", for: .normal)
                        print(vm.recordedDuration())
                    })
                })
            } else {
                stopRecording()
                self.capturePhotoBgView.stopProgress()
            }
        }
    }
}

//
//  CameraVM.swift
//  Peach
//
//  Created by Daniel on 9/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

// 1.建立AVCaptureSession
// 2.建立AVCaptureDevice
// 3.設定DeviceInput
// 4.設定PhotoOutputs

enum CameraConfigureError: Swift.Error {
    case noCamerasAvailable
    case noPhotoOutputAvailable
    case noVideoOutputAvailable
    case unknown
}

enum CameraPosition {
    case front
    case rear
}

class CameraVM: BaseVM {
    
    //MARK:- Property
    var type: AssetType = .photo
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.sessionQueue")
    
    private var frontCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var rearCameraInput: AVCaptureDeviceInput?
    private var currentCameraPosition: CameraPosition = .front
    
    private var photoOutput = AVCapturePhotoOutput()
    private var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    private var movieOutput = AVCaptureMovieFileOutput()
    private var videoDidStartBlock: ((CGFloat) -> Void)?
    private var videoCaptureCompletionBlock: ((AVAsset?, Error?) -> Void)?
    
    //MARK:- Initialize
    init(type: AssetType) {
        self.type = type
    }
    
    //MARK:- Public Function
    func returnCaptureSession() -> AVCaptureSession {
        return self.captureSession
    }
    
    func prepareCamera(completionHandler: @escaping (Error?) -> Void) {
        self.sessionQueue.async { [weak self] in
            do {
                try self?.configureCaptureDevices()
                try self?.configureDeviceInputs()
                
                if self?.type == .some(.photo) {
                    try self?.configurePhotoOutput()
                } else {
                    try self?.configureVideoOutput()
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func focus(with focusMode: AVCaptureDevice.FocusMode, exposureMode: AVCaptureDevice.ExposureMode, at devicePoint: CGPoint, monitorSubjectAreaChange: Bool) {
        
        self.sessionQueue.async {
            let device = (self.currentCameraPosition == .front) ? self.frontCamera! : self.rearCamera!
            do {
                try device.lockForConfiguration()
                
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                    device.focusPointOfInterest = devicePoint
                    device.focusMode = focusMode
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                    device.exposurePointOfInterest = devicePoint
                    device.exposureMode = exposureMode
                }
                
                device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
            }
        }
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        if !self.captureSession.isRunning { return }
        let setting = AVCapturePhotoSettings()
        self.photoOutput.capturePhoto(with: setting, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    func startRecording(didStartHandler: ((CGFloat) -> Void)?) {
        if !self.captureSession.isRunning { return }
        let connention = self.movieOutput.connection(with: .video)
        connention?.videoOrientation = .portrait
        
        let outputFileName = NSUUID().uuidString
        let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
        
        self.movieOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
        self.videoDidStartBlock = didStartHandler
    }
    
    func stopRecording(completion: @escaping (AVAsset?, Error?) -> Void) {
        if !self.movieOutput.isRecording && !self.captureSession.isRunning { return }
        self.movieOutput.stopRecording()
        self.videoCaptureCompletionBlock = completion
    }
    
    func isRecording() -> Bool {
        return self.movieOutput.isRecording
    }
    
    func recordedDuration() -> CGFloat {
        return CGFloat(round(CMTimeGetSeconds(self.movieOutput.recordedDuration)))
    }
    
    func startRunningCamera() {
        self.captureSession.startRunning()
    }
    
    func stopRunningCamera() {
        self.captureSession.stopRunning()
    }
    
    //MARK:- Private Function
    private func configureCaptureDevices() throws {
        if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.rearCamera = backCameraDevice
        }
        if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            self.frontCamera = frontCameraDevice
        }
        
        if self.frontCamera == nil && self.rearCamera == nil {
            throw CameraConfigureError.noCamerasAvailable
        }
    }
    
    private func configureDeviceInputs() throws {
        
        //相機
        if let rearCamera = self.rearCamera {
            do {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if self.captureSession.canAddInput(self.rearCameraInput!) {
                    self.captureSession.addInput(self.rearCameraInput!)
                }
                self.currentCameraPosition = .rear
            }
        } else if let frontCamera = self.frontCamera {
            do {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if self.captureSession.canAddInput(self.frontCameraInput!) {
                    self.captureSession.addInput(self.frontCameraInput!)
                }
                self.currentCameraPosition = .front
            }
        } else {
            throw CameraConfigureError.noCamerasAvailable
        }
        
        //麥克風
        if self.type == .video {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            do {
                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
                if self.captureSession.canAddInput(audioDeviceInput) {
                    self.captureSession.addInput(audioDeviceInput)
                }
            }
        }
    }

    private func configurePhotoOutput() throws {
        self.photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
        
        self.captureSession.beginConfiguration()
        self.captureSession.sessionPreset = .photo
        if self.captureSession.canAddOutput(self.photoOutput) {
            self.captureSession.addOutput(self.photoOutput)
        } else {
            throw CameraConfigureError.noPhotoOutputAvailable
        }
        self.captureSession.commitConfiguration()
    }
    
    private func configureVideoOutput() throws {
        self.captureSession.beginConfiguration()
        self.captureSession.sessionPreset = .high

        if self.captureSession.canAddOutput(self.movieOutput) {
            self.captureSession.addOutput(self.movieOutput)
        } else {
            throw CameraConfigureError.noVideoOutputAvailable
        }
        self.captureSession.commitConfiguration()
    }
}

extension CameraVM: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            self.photoCaptureCompletionBlock?(nil, error)
        } else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
            
            //儲存照片
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraConfigureError.unknown)
        }
    }
}

extension CameraVM: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        self.videoDidStartBlock?(recordedDuration())
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            self.videoCaptureCompletionBlock?(nil,error)
        } else {
            
            let avasset = AVAsset(url: outputFileURL)
            self.videoCaptureCompletionBlock?(avasset,nil)
            
            //儲存影片
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            }
        }
    }
}

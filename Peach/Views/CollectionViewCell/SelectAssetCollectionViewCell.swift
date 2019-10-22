//
//  SelectAssetCollectionViewCell.swift
//  Peach
//
//  Created by Daniel on 5/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

class SelectAssetCollectionViewCell: CoreCollectionViewCell {
        
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var coverView: UIView!
    
    private var imageIdentifier: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.layer.borderWidth = 0
        self.imageView.layer.removeAllSublayers()
        self.imageIdentifier = ""
        self.countLabel.isHidden = true
        self.timeLabel.isHidden = true
        self.coverView.isHidden = true
        self.isUserInteractionEnabled = true
    }
    
    override var item: RowItemProtocol? {
        didSet {
            if let dic = self.item?.value as? [String:Any], let asset = dic["photo"] as? CustomAsset, let imageManager = dic["imageManager"] as? PHImageManager, let thumbnailSize = dic["thumbnailSize"] as? CGSize {
                
                self.imageIdentifier = asset.originAsset.localIdentifier
                
                if asset.selected {
                    self.imageView.layer.borderWidth = 2.5
                    if let index = asset.selectIndex {
                        self.countLabel.isHidden = false
                        self.countLabel.text = String(index)
                    }
                } else {
                    self.imageView.layer.borderWidth = 0
                    self.countLabel.isHidden = true
                }
                
                if asset.originAsset.mediaType == .video {
                    self.timeLabel.text = asset.originAsset.duration.videoDurationString
                    self.timeLabel.isHidden = false
                    let isSelectable = asset.originAsset.duration.second <= 30 && asset.originAsset.duration.minute < 1
                    self.coverView.isHidden = isSelectable
                    self.isUserInteractionEnabled = isSelectable
                     
                    if let playingAssetIdentifier = CustomPlayer.shared.playingAssetIdentifier, playingAssetIdentifier == asset.originAsset.localIdentifier {
                        CustomPlayer.shared.play(at: self.imageView)
                    }
                    
                } else {
                    self.timeLabel.isHidden = true
                    self.coverView.isHidden = true
                    self.isUserInteractionEnabled = true
                }
                                                              
                let option: PHImageRequestOptions = PHImageRequestOptions()
                option.resizeMode = .none
                option.deliveryMode = .highQualityFormat
//                option.isSynchronous = true
//                option.isNetworkAccessAllowed = true
                
                imageManager.requestImage(for: asset.originAsset, targetSize: thumbnailSize, contentMode: .aspectFill, options: option, resultHandler: { [weak self] image, info in
                    if self?.imageIdentifier == asset.originAsset.localIdentifier {
                        self?.imageView.image = image
                    }
                })
            }
        }
    }
    
    func playVideo() {
        if let dic = self.item?.value as? [String:Any], let asset = dic["photo"] as? CustomAsset {
            if let playingAssetIdentifier = CustomPlayer.shared.playingAssetIdentifier, playingAssetIdentifier == asset.originAsset.localIdentifier, CustomPlayer.shared.isPlaying() { return }
            
            PHImageManager.default().requestAVAsset(forVideo: asset.originAsset, options: nil, resultHandler: { avasset, _, _ in
                if let video = avasset {
                    CustomPlayer.shared.setVideo(video: video, assetIdentifier: asset.originAsset.localIdentifier)
                    DispatchQueue.main.async {
                        CustomPlayer.shared.play(at: self.imageView)
                    }
                }
            })
        }
    }
    
    func pauseVideo() {
        CustomPlayer.shared.pause()
    }
    
    func resumePlayVideo() {
        CustomPlayer.shared.play(at: self.imageView)
    }
}

class CustomPlayer {
    static let shared = CustomPlayer()
    
    var playingAssetIdentifier: String?
    private var playerLayer = AVPlayerLayer()
    private var player = AVPlayer() {
        didSet {
            self.playerLayer.player = player
        }
    }
    
    private init () {
        self.playerLayer.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main, using: { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self.player.currentItem as Any)
    }
    
    func setVideo(video: AVAsset, assetIdentifier: String) {
        let playerItem = AVPlayerItem(asset: video)
        self.player = AVPlayer(playerItem: playerItem)
        self.playingAssetIdentifier = assetIdentifier
    }
    
    func play(at view: UIView) {
        DispatchQueue.main.async {
            self.playerLayer.frame = view.bounds
            view.layer.addSublayer(self.playerLayer)
            self.player.play()
        }
    }
    
    func pause() {
        self.player.pause()
    }
    
    func isPlaying() -> Bool {
        return self.player.timeControlStatus == .playing
    }
    
    func clean() {
        self.player.pause()
        self.player.replaceCurrentItem(with: nil)
        self.playingAssetIdentifier = nil
    }
}

//
//  VideoHelper.swift
//  Peach
//
//  Created by Daniel on 16/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

class VideoHelper {
    static var shared = VideoHelper()
    
    func fetchVideoImage(video: AVAsset, completion: @escaping ([UIImage]) -> Void) {
        //https://www.jianshu.com/p/f02aad2e7ff5
        //https://juejin.im/post/5cb3323c5188251d28699764
        let imageGenerator = AVAssetImageGenerator(asset: video)
        imageGenerator.appliesPreferredTrackTransform = true
        let space = video.duration.value / 9
        let times: [NSValue] = (0...9).map{ NSValue(time: CMTimeMake(value: space * Int64($0), timescale: video.duration.timescale)) }
        
        var images: [UIImage] = []
        imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestedTime, cgImage, actualTime, result, error) in
            if let cgImage = cgImage {
                images.append(UIImage(cgImage: cgImage))
            }
            
            if requestedTime.value == space * 9 {
                if images.count == 10 {
                    DispatchQueue.main.async {
                        completion(images)
                    }
                } else {
                    print("Fetch Video Image fail")
                }
            }
        })
    }
}

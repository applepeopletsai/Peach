//
//  TimeInterval_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
//https://stackoverflow.com/questions/30771820/swift-convert-milliseconds-into-minutes-seconds-and-milliseconds
extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minuteSecond: String {
        return String(format:"%02d:%02d", minute, second)
    }
    var hourMinuteSecond: String {
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    var hour: Int {
        return Int(self/3600)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(roundf(Float(self)).truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
    
    var videoDurationString: String {
        return (self > 3600) ? hourMinuteSecond : minuteSecond
    }
}

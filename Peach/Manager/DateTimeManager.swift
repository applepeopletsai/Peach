//
//  DateTimeManager.swift
//  VIP
//
//  Created by dean on 2018/6/19.
//  Copyright © 2018年 Phoenixnet. All rights reserved.
//

import Foundation

enum AccumulationLoginDateEnum :String {
    case sameDay = "sameDay"
    case tomorrow = "tomorrow"
    case resetDate = "resetDate"
}

class DateTimeManager {
    //Singleton
    static let shared = DateTimeManager()
    /*  can also use paramater to init
     let baseURL = ""
     private int(url:String) {
     self.baseURL = url
     }
     */
    //Initialization
    private init() {
        
    }
    
}
extension DateTimeManager {
    func convertSecondsToHMS(time:Float) -> String {
        let interval = time
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        //https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
        formatter.unitsStyle = .positional
        guard let formattedString = formatter.string(from: TimeInterval(interval)) else {
            return ""
        }
        return formattedString
        
    }
    
    /// Convert milliseconds to HH:mm:ss
    ///
    /// - Parameter milisecond: milliseconds
    /// - Returns: HH:mm:ss
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func milisecondToHMS(milisecond:Int) -> String {
        let second = milisecond / 1000
        let hour = second / 3600
        let min = (second % 3600) / 60
        let sec = (second % 3600) % 60
        return "\(hour):\(min):\(sec)"
    }
    func convertMillisecondsToHMS(milisecond:Int) ->String {
        let second = milisecond / 1000
        let formatter = DateFormatter()
        switch second {
        case ...60:
            formatter.dateFormat = "mm:ss"
            let date = Date(timeIntervalSince1970: (TimeInterval(second)))
            return formatter.string(from: date)
        case 61...:
            formatter.dateFormat = "mm:ss"
            let date = Date(timeIntervalSince1970: (TimeInterval(second)))
            var hourString = ""
            if second > 3600 {
                let hour = second - 3600
                switch hour {
                case ...9:
                    hourString = "0\(hour)"
                case 10...:
                    hourString = "\(hour)"
                default:
                    hourString = "00"
                }
                return "\(hourString):\(formatter.string(from: date))"
            } else {
                return formatter.string(from: date)
            }
            
        default:
            return "00:00"
        }
    }
    
    func convertJSONTimeToYearMonthDay(originDate:String) -> String? {
        let dateFormatter = DateFormatter()
        //            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let date = dateFormatter.date(from: originDate) {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = "yyyy/MM/dd"
            let string = newFormatter.string(from: date)
            return string
        }
        return nil
    }
    func convertJSONTime(originDate:String,newFormatter:DateFormatter) -> String? {
        let dateFormatter = DateFormatter()
        //            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let date = dateFormatter.date(from: originDate) {
//            let newFormatter = DateFormatter()
//            newFormatter.dateFormat = "yyyy/MM/dd"
            let string = newFormatter.string(from: date)
            return string
        }
        return nil
    }
    

    
    
    func checkLastLoginDate(now:Date,lastLoginDate:Date) -> AccumulationLoginDateEnum {
        let nowcomponent = Calendar.current.dateComponents([.year, .month, .day], from: now)
        let lastLoginComponent = Calendar.current.dateComponents([.year, .month, .day], from: lastLoginDate)
        if nowcomponent.year == lastLoginComponent.year && nowcomponent.month == lastLoginComponent.month {
            switch lastLoginComponent.day! - nowcomponent.day! {
            case 0:
                return .sameDay
            case 1:
                return .tomorrow
            case 2...:
                return .resetDate
            default:
//                return .resetDate
                print("checkLastLoginDate Error")
            }
            
        }
        return .resetDate
    }
    
    func convert1970(dateInt: Int) -> Date {
        let timeInterval:TimeInterval = TimeInterval(dateInt)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    func convert1970ToDate(dateInt: Int) -> String {
        let dformatter = DateFormatter()
        
        let timeInterval:TimeInterval = TimeInterval(dateInt)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        //let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy/MM/dd"
        
        return dformatter.string(from: date)
    }
    func convert1970ToDateWithFormatter(dateInt: Int,formatter:DateFormatter) -> String {
        
        
        let timeInterval:TimeInterval = TimeInterval(dateInt)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        //let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.string(from: date)
    }
}
//MARK: - MillisecondsTo HH:mm:ss
extension DateTimeManager {
    func getFormattedDurationString(trackDuration: NSNumber?) -> String {
        
        guard let trackDuration = trackDuration, trackDuration.doubleValue > 1000.0 else {
            return "00:00:00"
        }
        
        let milliseconds = trackDuration.doubleValue
        var seconds = milliseconds / 1000;
        var minutes = seconds / 60;
        seconds = seconds.truncatingRemainder(dividingBy: 60)
        let hours = minutes / 60;
        minutes = minutes.truncatingRemainder(dividingBy: 60)
        
        
        var timeComponents = Dictionary<String,Int>()
        timeComponents = ["hours":Int(hours), "minutes":Int(minutes),"seconds":Int(seconds)]
        
        return self.durationStringBuilder(timeComponents: timeComponents as NSDictionary?)
    }
    
    private func durationStringBuilder(timeComponents:NSDictionary?) -> String {
        
        var result:String = ""
        
        guard let timeComponents = timeComponents, timeComponents.count == 3 else {
            return result
        }
        
        let hours = setZeroPadding(timeComponent: timeComponents["hours"] as? Int, delimiter: false)
        let minutes = setZeroPadding(timeComponent: timeComponents["minutes"] as? Int, delimiter: false)
        let seconds = setZeroPadding(timeComponent: timeComponents["seconds"] as? Int, delimiter: true)
        
        result.append(hours)
        result.append(minutes)
        result.append(seconds)
        
        return result
    }
    private func setZeroPadding(timeComponent: Int?, delimiter: Bool) -> String {
        
        var result:String = ""
        
        guard let timeComponent = timeComponent, timeComponent > 0 else {
            if !delimiter {
                result.append("00:")
                return result
            } else {
                result.append("00")
                return result
            }
        }
        
        if(timeComponent < 10){
            if !delimiter {
                result.append("0\(timeComponent):")
            } else{
                result.append("0\(timeComponent)")
            }
        } else {
            if !delimiter {
                result.append("\(timeComponent):")
            } else{
                result.append("\(timeComponent)")
                
            }
        }
        
        return result
    }
}




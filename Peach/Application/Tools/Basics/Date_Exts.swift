//
//  Date_Exts.swift
//  Peach
//
//  Created by Daniel on 4/09/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

extension Date {
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
}

//
//  URL_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
extension URL {
    static func getRandomImageURL() -> URL {
        let rand = Int(arc4random_uniform(1000))
        return URL(string: "https://picsum.photos/200/300?image=\(rand)")!
    }
}

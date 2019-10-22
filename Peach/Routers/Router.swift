//
//  Router.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
}



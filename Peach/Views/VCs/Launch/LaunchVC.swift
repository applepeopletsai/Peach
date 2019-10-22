//
//  LaunchVC.swift
//  Peach
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import UIKit

//Step1: Check IP....
//Step2: Check app version...
//Step3: Check balabala...
//...

//Step final: All checked, all good, that's go to main VC

class LaunchVC: CoreVC {
    
    var launchLoginRouter:LaunchLoginRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.launchLoginRouter = LaunchLoginRouter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //「偏好設定」已設定完成
        let stringTo:String = LaunchLoginRouteID.preferenceSettingComplete.rawValue

        self.launchLoginRouter?.route(to: stringTo, from: self.navigationController!, parameters: nil)
        
    }

}

//
//  TrialSetup.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 10/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

struct TrialSetup {
    
    let stageName:String?
    let waitingPeriod:Double?
    let stageNumber:Int?
    
    init(name:String, waitPeriod:Double, stageNum:Int) {
        stageName = name
        waitingPeriod = waitPeriod
        stageNumber = stageNum
    }
}

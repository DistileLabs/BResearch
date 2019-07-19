//
//  rawData.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 15/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

struct rawData {
    
    var stageNumber: Int?
    var stageData:String?
    
    init(addStageNumber: Int, addStageData:String) {
        stageNumber = addStageNumber
        stageData = addStageData
    }
}

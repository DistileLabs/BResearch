//
//  rawData.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 15/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class rawData: NSObject, NSCoding {
    
    var stageNumber: Int?
    var stageData:String?
    
    init(addStageNumber: Int, addStageData:String) {
        stageNumber = addStageNumber
        stageData = addStageData
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(stageData, forKey: "stageData")
        aCoder.encode(stageNumber, forKey: "stageNumber")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let stageD = aDecoder.decodeObject(forKey: "stageData") as! String
        let stageNum = aDecoder.decodeObject(forKey: "stageNumber") as! Int
        self.init(addStageNumber: stageNum, addStageData:stageD)
    }
    
}

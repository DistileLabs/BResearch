//
//  TrialSetup.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 10/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class TrialSetup: NSObject, NSCoding {
    
    let stageName:String?
    let waitingPeriod:Int?
    let stageNumber:Int?
    
    init(name:String, waitPeriod:Int, stageNum:Int) {
        stageName = name
        waitingPeriod = waitPeriod
        stageNumber = stageNum
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(stageName, forKey: "stageName")
        aCoder.encode(waitingPeriod, forKey: "waitingPeriod")
        aCoder.encode(stageNumber, forKey: "stageNumber")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let stageN = aDecoder.decodeObject(forKey: "stageName") as! String
        let waitP = aDecoder.decodeInteger(forKey: "waitingPeriod")
        let stageNum = aDecoder.decodeInteger(forKey: "stageNumber")
        
        self.init(name: stageN, waitPeriod: waitP, stageNum: stageNum)
    }
    
}

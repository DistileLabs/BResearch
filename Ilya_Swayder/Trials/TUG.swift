//
//  TUG.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 19/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class TugTrial: Trial {
    
    init(newName: String = "TUG", flow:[TrialSetup] = [TrialSetup(name: "Get Ready for TUG trial", waitPeriod: 1, stageNum: 0),
                                                       TrialSetup(name: "TUG trial", waitPeriod: 1, stageNum: 1),])
    {
        super.init(trialName: newName, flow: flow, status: false)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        //let trialName = aDecoder.decodeObject(forKey: "trialName") as! String
        let finishStatus = aDecoder.decodeBool(forKey: "isFinished")
        let tFlow = aDecoder.decodeObject(forKey: "flow") as! [TrialSetup]
        let data = aDecoder.decodeObject(forKey: "data") as? [rawData]
        
        self.init()
        
        isFinished = finishStatus
        trialFlow = tFlow
        trialRawData = data
    }
}
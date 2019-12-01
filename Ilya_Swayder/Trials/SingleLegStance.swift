//
//  TrialModel.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 18/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class SingleLegStanceTrial: Trial {

    init(newName: String = "Single Leg Stance", flow:[TrialSetup] = [TrialSetup(name: "Get Ready for SLS1", waitPeriod: 10, stageNum: 0),
                                               TrialSetup(name: "SLS1", waitPeriod: 10, stageNum: 1),
                                               TrialSetup(name: "Get Ready for SLS2", waitPeriod: 10, stageNum: 2),
                                               TrialSetup(name: "SLS2", waitPeriod: 10, stageNum: 3),
                                               TrialSetup(name: "Get Ready SLS3", waitPeriod: 10, stageNum: 4),
                                               TrialSetup(name: "SLS3", waitPeriod: 10, stageNum: 5),]) {
        super.init(trialName: newName, flow: flow, status: NOT_FINISHED, audioFile: "sls_with_time")
    }
    //, audioFile:"sls_with_time"
    required convenience init(coder aDecoder: NSCoder) {
        let trialName = aDecoder.decodeObject(forKey: "trialName") as! String
        let finishStatus = aDecoder.decodeInteger(forKey: "isFinished")
        let tFlow = aDecoder.decodeObject(forKey: "flow") as! [TrialSetup]
        let data = aDecoder.decodeObject(forKey: "data") as? [rawData]
        let audioFile = aDecoder.decodeObject(forKey: "audio") as? String
        
        self.init()
        
        isFinished = finishStatus// ?? NOT_FINISHED
        trialFlow = tFlow
        trialRawData = data
        audioFileName = audioFile
    }
}

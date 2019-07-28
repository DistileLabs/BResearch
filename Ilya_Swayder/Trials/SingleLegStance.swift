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
    
    let waitingPeriod = 5

    init(newName: String = "Single Leg Stance", flow:[TrialSetup] = [TrialSetup(name: "Get Ready for SLS1", waitPeriod: 1, stageNum: 0),
                                               TrialSetup(name: "SLS1", waitPeriod: 1, stageNum: 1),
                                               TrialSetup(name: "Get Ready for SLS2", waitPeriod: 1, stageNum: 2),
                                               TrialSetup(name: "SLS2", waitPeriod: 1, stageNum: 3),
                                               TrialSetup(name: "Get Ready SLS3", waitPeriod: 1, stageNum: 4),
                                               TrialSetup(name: "SLS3", waitPeriod: 1, stageNum: 5),]) {
        super.init()
        name = newName
        
        trialFlow = flow
    }
}

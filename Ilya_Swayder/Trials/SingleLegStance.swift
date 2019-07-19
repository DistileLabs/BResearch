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

    init(newName: String = "Single Leg Stance", flow:[TrialSetup] = [TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                               TrialSetup(name: "First stage", waitPeriod: 5, stageNum: 1),
                                               TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 2),
                                               TrialSetup(name: "Second stage", waitPeriod: 5, stageNum: 3),
                                               TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 4),
                                               TrialSetup(name: "Last stage", waitPeriod: 5, stageNum: 5),]) {
        super.init()
        name = newName
        
        trialFlow = flow
    }
}

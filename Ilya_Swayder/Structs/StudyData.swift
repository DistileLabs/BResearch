//
//  StudyData.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 19/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

enum StudyError: Error {
    
    case trialNameNotExists(requstedTrial: String)
}

struct StudyData {
    
    private var paritcipantID: String
    
    var SingleLegStance:SingleLegStanceTrial = SingleLegStanceTrial()
    var TUG:TugTrial = TugTrial()
    var TugReliability: TugReliabilityTrial = TugReliabilityTrial()
    
    init(newParticipant id : String) {
        
        paritcipantID = id
    }

    func getName() -> String? {
        
        return paritcipantID
    }
    
    func runTrials(trialName: String) throws{
    
        switch trialName {
        case "Single let stance":
            SingleLegStance.run()
        case "TUG":
            TUG.run()
        case "TUG reliability":
            TugReliability.run()
        default:
            throw StudyError.trialNameNotExists(requstedTrial: trialName)
        }
    }

    func isTrialFinished(trialName: String) -> Bool{
        
        switch trialName {
        case "Single let stance":
            return SingleLegStance.isFinished
        case "TUG":
            return TUG.isFinished
        case "TUG reliability":
            return TugReliability.isFinished
        default:
            return false
        }
    }
    
    func isAllMandatoryTrialFinished() -> Bool {
        
        if SingleLegStance.isFinished == true
        {
            if TUG.isFinished == true || TugReliability.isFinished == true
            {
                return true
            }
        }
        
        return false
    }
}

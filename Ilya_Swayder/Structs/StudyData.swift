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

class StudyData:NSObject,NSCoding {
    

    private var paritcipantID: String
    var isSynced:Bool = false
    
    var SingleLegStance:SingleLegStanceTrial = SingleLegStanceTrial()
    var TUG:TugTrial = TugTrial()
    var TugReliability: TugReliabilityTrial = TugReliabilityTrial()
    
    init(newParticipant id : String) {
        
        paritcipantID = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(paritcipantID, forKey: "paritcipantID")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let participant = aDecoder.decodeObject(forKey: "paritcipantID") as! String
        
        self.init(newParticipant: participant)
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
        case SingleLegStance.getName():
            return SingleLegStance.isFinished
        case TUG.getName():
            return TUG.isFinished
        case TugReliability.getName():
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

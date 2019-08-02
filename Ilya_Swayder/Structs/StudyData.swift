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
    var time:String = ""
    
    var SingleLegStance:SingleLegStanceTrial!
    var TUG:TugTrial!
    var TugReliability: TugReliabilityTrial!
    
    init(newParticipant id : String, timeAndDate:String, synced:Bool) {
        paritcipantID = id
        time = timeAndDate
        isSynced = synced
        
        SingleLegStance = SingleLegStanceTrial()
        TUG = TugTrial()
        TugReliability = TugReliabilityTrial()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(paritcipantID, forKey: "paritcipantID")
        aCoder.encode(time, forKey: "timeAndDate")
        aCoder.encode(isSynced, forKey: "isSynced")
        aCoder.encode(SingleLegStance, forKey: "slsCode")
        aCoder.encode(TUG, forKey: "tugCode")
        aCoder.encode(TugReliability, forKey: "tugReCode")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let participant = aDecoder.decodeObject(forKey: "paritcipantID") as! String
        let time = aDecoder.decodeObject(forKey: "timeAndDate") as? String ?? "nil"
        let sync = aDecoder.decodeBool(forKey: "isSynced")
        let sls = aDecoder.decodeObject(forKey: "slsCode") as? SingleLegStanceTrial
        let tug = aDecoder.decodeObject(forKey: "tugCode") as? TugTrial
        let tugRe = aDecoder.decodeObject(forKey: "timeAndDate") as? TugReliabilityTrial
        
        self.init(newParticipant: participant, timeAndDate:time, synced:sync)
        
        SingleLegStance = sls
        TUG = tug
        TugReliability = tugRe
        
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

//
//  TugReliability.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 19/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class TugReliabilityTrial: Trial {
    
    let firstCycle:[Int] = [1,1,2,2]
    let secondCycle:[Int] = [1,2,1,2]


    init(newName: String = "TUG Realiability", flow:[TrialSetup] = [TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater A \nFirst stage", waitPeriod: 5, stageNum: 1),
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater A \nSecond stage", waitPeriod: 5, stageNum: 1) ,
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater B \nFirst stage", waitPeriod: 5, stageNum: 1) ,
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater B \nSecond stage", waitPeriod: 5, stageNum: 1),])
    {
        super.init(trialName: newName, flow: flow, status: NOT_FINISHED, audioFile: "tug_with_time")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        //let trialName = aDecoder.decodeObject(forKey: "trialName") as! String
        let finishStatus = aDecoder.decodeInteger(forKey: "isFinished")
        let tFlow = aDecoder.decodeObject(forKey: "flow") as! [TrialSetup]
        let data = aDecoder.decodeObject(forKey: "data") as? [rawData]
        let audioFile = aDecoder.decodeObject(forKey: "audio") as? String
        let phase = aDecoder.decodeInteger(forKey: "currentPhase")
        
        
        self.init()
        
        isFinished = finishStatus //?? NOT_FINISHED
        trialFlow = tFlow
        trialRawData = data
        audioFileName = audioFile
        currentPhase = phase
    }
    
    func getPhaseNumber() -> Int {
        return currentPhase % 2
    }
    
    override func setTrialStatus(isFinishedStatus: Int) {
        
        if isFinishedStatus == FINISHED {
            currentPhase += 1
            
            if currentPhase == 2 {
               cycleNumber += 1
            }
        }
    }
    
    override func isSpecificTrialFinished() -> Int {
        if currentPhase == 2 {
            return FINISHED
        }
        else if currentPhase == 1 {
            return IN_PROGRESS
        }
        else {
            return NOT_FINISHED
        }
    }
    
    override func getTrialStage(at index: Int) -> TrialSetup? {
        
        let currentCycleNumber = cycleNumber % 4
        var trialFlowArray:[TrialSetup] = trialFlow!
        
        if currentPhase == 0 {
            
            if firstCycle[currentCycleNumber] == 2 {
                trialFlowArray.swapAt(1, 5)
                trialFlowArray.swapAt(3, 7)
            }
        }
        else if currentPhase == 1{
            if secondCycle[currentCycleNumber] == 2 {
                trialFlowArray.swapAt(1, 5)
                trialFlowArray.swapAt(3, 7)
            }
            
            
        }
 
        return trialFlowArray[index]
        
    }
}

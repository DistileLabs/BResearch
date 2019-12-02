//
//  TugReliability.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 19/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

struct Phase {
    let firstCycle:[Int]
    let secondCycle:[Int]
}

private let A = Phase(firstCycle: [1,1,2,2], secondCycle: [1,1,2,2])
private let B = Phase(firstCycle: [1,1,2,2], secondCycle: [2,2,1,1])
private let C = Phase(firstCycle: [2,2,1,1], secondCycle: [1,1,2,2])
private let D = Phase(firstCycle: [2,2,1,1], secondCycle: [2,2,1,1])
private let randomization:[Phase] = [C,B,C,A,D,C,A,C,B,C,A,D,B,A,D,A,D,B,D,B]
var cycleNumber:Int = 0

class TugReliabilityTrial: Trial {
    
    init(newName: String = "TUG Realiability", flow:[TrialSetup] = [TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater A", waitPeriod: 5, stageNum: 1),
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater A", waitPeriod: 5, stageNum: 1) ,
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater B", waitPeriod: 5, stageNum: 1) ,
                                                                    TrialSetup(name: "Get Ready", waitPeriod: 5, stageNum: 0),
                                                                    TrialSetup(name: "TUG - Rater B", waitPeriod: 5, stageNum: 1),])
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
        
        let currentCycleNumber = cycleNumber % randomization.count
        let firstCycle = randomization[currentCycleNumber].firstCycle
        let secondCycle = randomization[currentCycleNumber].secondCycle
        let trialFlowArray:[TrialSetup] = trialFlow!
        var currentFlow:TrialSetup?
        
        if index % 2 == 0 {
            currentFlow = trialFlowArray[0]
        } else {
            if currentPhase == 0 {
                
                if firstCycle[index / 2 ] == 2 {
                        
                      currentFlow =  trialFlowArray.filter({$0.stageName == "TUG - Rater B"})[0]
    //                trialFlowArray.swapAt(1, 5)
    //                trialFlowArray.swapAt(3, 7)
                } else {
                    currentFlow = trialFlowArray.filter({$0.stageName == "TUG - Rater A"})[0]
                }
            }
            else if currentPhase == 1{
                if secondCycle[index / 2] == 2 {
                     currentFlow = trialFlowArray.filter({$0.stageName == "TUG - Rater B"})[0]
                } else {
                    currentFlow = trialFlowArray.filter({$0.stageName == "TUG - Rater A"})[0]
                }
            }
        }
        
        return currentFlow
        
    }
}

//
//  Trial.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 11/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class Trial:NSObject, NSCoding{
    
    var name:String = ""
    var isFinished:Int = NOT_FINISHED
    var trialFlow:[TrialSetup]?
    var trialRawData:[rawData]?
    var audioFileName:String?
    var currentPhase:Int = 0
 
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "trialName")
        aCoder.encode(isFinished, forKey: "isFinished")
        aCoder.encode(trialFlow, forKey: "flow")
        aCoder.encode(trialRawData, forKey: "data")
        aCoder.encode(audioFileName, forKey: "audio")
        aCoder.encode(currentPhase,forKey: "currentPhase")
    }

    required convenience init(coder aDecoder: NSCoder) {
        let trialName = aDecoder.decodeObject(forKey: "trialName") as! String
        let finishStatus = aDecoder.decodeInteger(forKey: "isFinished")
        let tFlow = aDecoder.decodeObject(forKey: "flow") as! [TrialSetup]
        let data = aDecoder.decodeObject(forKey: "data") as! [rawData]
        let audioFileLoad = aDecoder.decodeObject(forKey: "audio") as? String
        let phase = aDecoder.decodeInteger(forKey: "currentPhase")
        
        self.init(trialName:trialName, flow:tFlow, status: finishStatus, audioFile:audioFileLoad!)

        trialRawData = data
        currentPhase = phase
    }
    
    init(trialName:String, flow:[TrialSetup], status:Int, audioFile:String) {
        
        name = trialName
        trialFlow = flow
        isFinished = status
        audioFileName = audioFile
    }
    
    func getTrialFlowCount() -> Int? {
        return trialFlow?.count
    }
    
    func getTrialStage(at index: Int) -> TrialSetup? {
        return trialFlow![index]
    }
    
    func run() {
        print("Fool its interface in Swift")
    }
        
    func getData() {
        print("Fool its interface in Swift")
    }
    
    func setName(newName: String) {
        name = newName
    }
    
    func getName() -> String {
        return name
    }
    
    func addRawData(data:rawData) {
        trialRawData?.append(data)
    }
    
    func setRawData(data:[rawData]) {
        
        if trialRawData == nil {
            
            trialRawData = data
        }
        else {
            
            trialRawData! += data
        }
    }
    
    func setTrialStatus(isFinishedStatus:Int)
    {
        isFinished = isFinishedStatus
    }
    
    func getRawData() -> [rawData]?{
        return trialRawData
    }
    
    func eraseRawDate() {
        trialRawData?.removeAll()
    }
    
    func isSpecificTrialFinished() -> Int {
        
        return isFinished
    }
}


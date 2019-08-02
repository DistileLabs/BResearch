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
    var isFinished:Bool = false
    var trialFlow:[TrialSetup]?
    var trialRawData:[rawData]?
 
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "trialName")
        aCoder.encode(isFinished, forKey: "isFinished")
        aCoder.encode(trialFlow, forKey: "flow")
        aCoder.encode(trialRawData, forKey: "data")
        
    }

    required convenience init(coder aDecoder: NSCoder) {
        let trialName = aDecoder.decodeObject(forKey: "trialName") as! String
        let finishStatus = aDecoder.decodeBool(forKey: "isFinished")
        let tFlow = aDecoder.decodeObject(forKey: "flow") as! [TrialSetup]
        let data = aDecoder.decodeObject(forKey: "data") as! [rawData]

        self.init(trialName:trialName, flow:tFlow, status: finishStatus)

        trialRawData = data
    }
    
    init(trialName:String, flow:[TrialSetup], status:Bool) {
        
        name = trialName
        trialFlow = flow
        isFinished = status
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
        trialRawData = data
    }
    
    func setTrialStatus(isFinishedStatus:Bool)
    {
        isFinished = isFinishedStatus
    }
    
    func getRawData() -> [rawData]?{
        return trialRawData
    }
}


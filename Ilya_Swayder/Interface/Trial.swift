//
//  Trial.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 11/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class Trial {
    
    var name:String = ""
    var isFinished:Bool = false
    var trialFlow:[TrialSetup]?
    var trialRawData:[rawData]?
 
    
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


//
//  uploadCounter.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 06/08/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

class UploadCounter {
    
    let semaphore = DispatchSemaphore(value: 1)
    var numOfFiles = 0
    
    func incrementFile() {
        
        semaphore.wait()
        
        numOfFiles += 1
        
        print("Incremented to : \(numOfFiles)")
        
        semaphore.signal()
    }
    
    func decrementFile() -> Int{
        
        semaphore.wait()
        
        numOfFiles -= 1
        
        let returnValue = numOfFiles
        
        print("Decremented to : \(numOfFiles)")
        
        semaphore.signal()
        
        return returnValue
    }
    
    func setNumberToSync(_ num: Int) {
        numOfFiles = num
    }
}

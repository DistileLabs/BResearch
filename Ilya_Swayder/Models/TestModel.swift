//
//  TestModel.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 10/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import CoreMotion

class TestModel {
    
    var motion: CMMotionManager = CMMotionManager()
    var getDataIntication:Bool = true
    var deviceMotionData:CMDeviceMotion = CMDeviceMotion()
    var deviceMotionDataString:String = ""
    var timeInterval:TimeInterval = 0.0
    
    func startDeviceMotion(maxTime: Int) {
        
        var isFirst:Bool = true
        var firstTimeInterval:TimeInterval = 0.0
        
        deviceMotionDataString = initStringData()

        if self.motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 100.0  // 100 Hz
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.current!, withHandler: {(data, error) in
            
                if (error != nil) {
                    print(error as Any)
                } else {
                    
                    if isFirst == true {
                        firstTimeInterval = data!.timestamp
                        isFirst = false
                    }
                    
                    let time = data!.timestamp - firstTimeInterval
                    
                    if Int(time) < maxTime {
                        var currentData:String = data.map {"\(time),\($0.userAcceleration.x),\($0.userAcceleration.y),\($0.userAcceleration.z),\($0.rotationRate.x),\($0.rotationRate.y),\($0.rotationRate.z),\($0.gravity.x),\($0.gravity.y),\($0.gravity.z),\($0.attitude.pitch),\($0.attitude.yaw),\($0.attitude.roll),\($0.attitude.quaternion.x),\($0.attitude.quaternion.y),\($0.attitude.quaternion.z),\($0.attitude.quaternion.w)"}!
                        
                        currentData.append("\n")
                        
                        self.deviceMotionDataString.append(currentData)
                    }
                }
            })
        }
    }
    
    func stopDeviceMotion() {
        motion.stopDeviceMotionUpdates()
    }
    
    func getMotionData() -> String? {
        return deviceMotionDataString
    }
    
    func resetData() {
        deviceMotionDataString = initStringData()
    }
    
    private func initStringData() -> String {
        
        return "Timestamp, Acceleration_X, Acceleration_Y, Acceleration_Z, Rotation_X, Rotation_Y, Rotation_Z, Gravity_X, Gravity_Y, Gravity_Z, Pitch, Yaw, Roll, Quaternion_X,  Quaternion_Y,  Quaternion_Z, Quaternion_W\n"
    }
}

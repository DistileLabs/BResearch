//
//  TestView.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 27/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//
import UIKit


class TestView: UIView {
 
    @IBOutlet var testViewConnect: UIView!
    @IBOutlet weak var rewind: UIButton!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var fastForward: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    let testModel:TestModel = TestModel()
    
    private var timerSeconds:Int = 0
    private var timer:Timer?
    private var isTrialFinished: Bool = false
    var navController:UINavigationController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("TestView", owner: self, options: nil)
        
        self.addSubview(self.testViewConnect)
        
    }
    
//    func runTimer() {
//
//        if timer == nil {
//            isTrialFinished = false
//            timerLabel.text = String(timerSeconds)//timeString(time: TimeInterval(timerSeconds))
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//            testModel.startDeviceMotion()
//        }
//    }
    
//    @objc func updateTimer() {
//
//        if timerSeconds <= 0
//        {
//            if timer != nil {
//            timer!.invalidate()
//            testModel.stopDeviceMotion()
//            isTrialFinished = true
//            timer = nil
//            navController.popViewController(animated: true)
//                navController.
//
//            }
//        }
//        else
//        {
//            timerSeconds -= 1
//            timerLabel.text = String(timerSeconds)//timeString(time: TimeInterval(timerSeconds))
//
//        }
//    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    

    
    func isFinished(completion:(Bool)->()){
        
        while (isTrialFinished == false) {
            sleep(1)
        }
        
        completion(true)
    }
}


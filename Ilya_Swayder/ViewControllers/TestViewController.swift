//
//  TestViewController.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 09/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion



class TestViewController: UIViewController, UINavigationControllerDelegate {

    var currentTrial:Trial!
    private var timer:Timer?
    var navController:UINavigationController!
    private var timerSeconds:Int = 0
    private var stageNumber:Int = 0
    private var totalStages:Int = 0
    private var trialRawData = [rawData]()
    private var isPaused:Bool = false
    private var currentPhase:TrialSetup!
    var audioPlayer:swayderAudioPlayer = swayderAudioPlayer()


    private var Get_Ready:String = "Get Ready"
    @IBOutlet weak var fixedTestView: TestView!
    
    override func viewDidLoad() {
        
        initButtonsAction()
        totalStages = currentTrial.getTrialFlowCount()!

        runPhase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       audioPlayer.pauseAudio()
        UIApplication.shared.isIdleTimerDisabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(closeActivityController), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setupUI()
    {
        currentPhase = currentTrial.getTrialStage(at: stageNumber)//currentTrial.trialFlow![stageNumber]
        
        fixedTestView.navController = navController
        
        fixedTestView.name.text = currentPhase.stageName

        setTimeForTimer(seconds: Int(currentPhase.waitingPeriod!))
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if (phasePreFix == Get_Ready )
        {
            fixedTestView.name.backgroundColor = UIColor(named: K.Colors.brandPinkDark)//UIColor.init(red: 23.0/255, green: 72.0/255, blue: 111.0/255, alpha: 1)
            fixedTestView.pause.alpha = 1
            fixedTestView.pause.isEnabled = true
        }
        else
        {
            fixedTestView.name.backgroundColor = UIColor(named: K.Colors.brandOrangeDark)//UIColor.init(red: 40.0/255, green: 139.0/255, blue: 39.0/255, alpha: 1)
            fixedTestView.pause.alpha = 0.5
            fixedTestView.pause.isEnabled = false
        }
    }
    
    func initButtonsAction() {
        
        fixedTestView.pause.addTarget(self, action: #selector(pauseButton), for: .touchUpInside)
        fixedTestView.fastForward.addTarget(self, action: #selector(fastForwardButton), for: .touchUpInside)
        fixedTestView.rewind.addTarget(self, action: #selector(rewindButton), for: .touchUpInside)
        fixedTestView.returnButton.addTarget(self, action: #selector(returnToMenu), for: .touchUpInside)
    }
    
    func getData () -> String{
    
        return self.fixedTestView.testModel.getMotionData()!
    }
    
    func runPhase() {
        setupUI()
        runTimer()
    }
    
    func runTimer() {
        
        if timer == nil {
            fixedTestView.timerLabel.text = String(timerSeconds)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
            if phasePreFix != Get_Ready {
                fixedTestView.testModel.startDeviceMotion(maxTime: currentPhase.waitingPeriod!)
            }
        }
    }
    
    @objc func updateTimer() {
        
        if timerSeconds <= 0
        {
            if timer != nil {
                timer!.invalidate()

                fixedTestView.testModel.stopDeviceMotion()
                timer = nil
                nextMove()
            }
        }
        else
        {
 
            if timerSeconds == 1{
               audioPlayer.playAudio(fileName: "beep", fileExtension: "mp3")
            }
            scheduleAudioFile(secondsLeft: timerSeconds)
            timerSeconds -= 1
            fixedTestView.timerLabel.text = String(timerSeconds)
        }
    }
    
    func setTimeForTimer(seconds: Int) {
        timerSeconds = seconds
    }
    
    func collectData() {
        trialRawData.append(rawData(addStageNumber: getDataStageNumber(stageNum: stageNumber), addStageData: getData()))
    }
    
    func nextMove() {
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if phasePreFix != Get_Ready {
            collectData()
        }
        stageNumber += 1
        
        if totalStages > stageNumber {
            runPhase()
        }
        else
        {
            endTrial()
        }
    }
    
    func endTrial() {
        
        let returnVC = navController.viewControllers[navController.viewControllers.count - 2] as! ParticipantViewController
        
        returnVC.returnDataFromTest(testName: currentTrial.getName(), rawDataSet: trialRawData)
        
        navController.popViewController(animated: true)
        
        return
    }
    
    @objc func pauseButton() {
        
        if isPaused == false {
            
            pause()
        }
        else
        {
            restart()
        }
    }
    
    @objc func fastForwardButton() {
        audioPlayer.stopPlaying()
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if phasePreFix != Get_Ready {
            collectData()
        }
        if let newStage = searchForClosestGetReadyPhase(fromStart: false, doubeTap: false) {
            stageNumber = newStage
            pause()
            //fixedTestView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
            runPhase()
        }
        else {
            timer?.invalidate()
            fixedTestView.testModel.stopDeviceMotion()
            endTrial()
        }
    }
    
    @objc func rewindButton() {
        audioPlayer.stopPlaying()
        
        let isDoubleTap = (currentPhase.waitingPeriod! - 1) <= timerSeconds ? true:false
        
        if let newStage = searchForClosestGetReadyPhase(fromStart: true, doubeTap: isDoubleTap) {
            stageNumber = newStage
            pause()
            //fixedTestView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
            runPhase()
        }
    }
    
    @objc func returnToMenu() {
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if phasePreFix == Get_Ready {
            pause()
        }
        let alert = UIAlertController(title: "Discard Trial ?", message: "Discarding trial would delete any progress made", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.timer?.invalidate()
            self.audioPlayer.stopPlaying()
            self.navController.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            if phasePreFix == self.Get_Ready {
                self.restart()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func pause() {
        //fixedTestView.pause.setImage(UIImage(named: "icons8-play"), for: .normal)
        isPaused = true
        timer?.invalidate()
        timer = nil
        audioPlayer.pauseAudio()
    }
    
    func restart() {
        //fixedTestView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
        isPaused = false
        runTimer()
        audioPlayer.unpauseAudio()
    }
    
    func searchForClosestGetReadyPhase (fromStart:Bool, doubeTap:Bool) -> Int? {
        
        if fromStart == true {
            
            if stageNumber == 0 {return 0}
            if doubeTap == true {stageNumber -= 1}
            
            for stage in (0...stageNumber).reversed() {
                
                let flow = currentTrial.trialFlow!
                
                let phasePreFix = String((flow[stage].stageName?.prefix(9))!)
                if phasePreFix == Get_Ready {
                    return stage
                }
            }
        }
        else
        {
            if (stageNumber + 1) < (currentTrial.trialFlow!.count - 1) {
                
                for stage in ((stageNumber + 1)...(currentTrial.trialFlow!.count - 1)) {
                    
                    let flow = currentTrial.trialFlow!
                    
                    let phasePreFix = String((flow[stage].stageName?.prefix(9))!)
                    if phasePreFix == Get_Ready {
                        
                        return stage
                    }
                }
            }
        }
        return nil
    }
    
    func clearRawData() {
        
        trialRawData.removeAll()
    }
    
    func scheduleAudioFile(secondsLeft:Int) {
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)

        if (secondsLeft == (audioPlayer.audioLengthGe(fileName: currentTrial.audioFileName!, fileExtension: "mp3") + 2) && (phasePreFix == Get_Ready)) {
            audioPlayer.playAudio(fileName: currentTrial.audioFileName!, fileExtension: "mp3")
        }
    }
    
    func getDataStageNumber(stageNum:Int) -> Int{
        
        var number:Int = 0
        
        switch(stageNum) {
            
            case 1:
                number = 1
                break
            case 2:
                number = 2
            case 3:
                number = 2
                break
            case 4:
                number = 3
            case 5:
                number = 3
                break
            case 6:
                number = 4
            case 7:
                number = 4
            case 8:
                number = 5
            case 9:
                number = 6
            case 10:
                number = 6
        default:
            return number
        }
        
        return number
    }
    
    @objc func closeActivityController() {
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if phasePreFix != Get_Ready {
            let alert = UIAlertController(title: "Experiment was interrupted !", message: "Last phase needs to be repeated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
  
            }))
            
            self.present(alert, animated: true)
        }
        
        rewindButton()
        pause()
    }
}

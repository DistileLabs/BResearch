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
    
    @IBOutlet var testView: TestView!
    
    override func viewDidLoad() {
        
        initButtonsAction()
        totalStages = currentTrial.trialFlow!.count

        runPhase()
    }
    
    func setupUI()
    {
        currentPhase = currentTrial.trialFlow![stageNumber]
        
        testView.navController = navController
        
        testView.name.text = currentPhase.stageName

        setTimeForTimer(seconds: Int(currentPhase.waitingPeriod!))
        let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
        if (phasePreFix == Get_Ready )
        {
            testView.name.backgroundColor = UIColor.init(red: 23.0/255, green: 72.0/255, blue: 111.0/255, alpha: 1)
            testView.pause.isHidden = false
        }
        else
        {
            testView.name.backgroundColor = UIColor.init(red: 40.0/255, green: 139.0/255, blue: 39.0/255, alpha: 1)
            testView.pause.isHidden = true
        }
    }
    
    func initButtonsAction() {
        
        testView.pause.addTarget(self, action: #selector(pauseButton), for: .touchUpInside)
        testView.fastForward.addTarget(self, action: #selector(fastForwardButton), for: .touchUpInside)
        testView.rewind.addTarget(self, action: #selector(rewindButton), for: .touchUpInside)
        testView.returnButton.addTarget(self, action: #selector(returnToMenu), for: .touchUpInside)
    }
    
    func getData () -> String{
    
        return self.testView.testModel.getMotionData()!
    }
    
    func runPhase() {
        setupUI()
        runTimer()
    }
    
    func runTimer() {
        
        if timer == nil {
            testView.timerLabel.text = String(timerSeconds)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            let phasePreFix = String((currentPhase.stageName?.prefix(9))!)
            if phasePreFix != Get_Ready {
                testView.testModel.startDeviceMotion(maxTime: currentPhase.waitingPeriod!)
            }
        }
    }
    
    @objc func updateTimer() {
        
        if timerSeconds <= 0
        {
            if timer != nil {
                timer!.invalidate()

                testView.testModel.stopDeviceMotion()
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
            testView.timerLabel.text = String(timerSeconds)
        }
    }
    
    func setTimeForTimer(seconds: Int) {
        timerSeconds = seconds
    }
    
    func collectData() {
        trialRawData.append(rawData(addStageNumber: stageNumber, addStageData: getData()))
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
            prepareForPop()
            navController.popViewController(animated: true)
        }
    }
    
    func prepareForPop() {
        
        let returnVC = navController.viewControllers[navController.viewControllers.count - 2] as! ParticipantViewController
        
        returnVC.returnDataFromTest(testName: currentTrial.getName(), rawDataSet: trialRawData)
        
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
        if let newStage = searchForClosestGetReadyPhase(fromStart: false, doubeTap: false) {
            stageNumber = newStage
            pause()
            testView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
            runPhase()
        }
    }
    
    @objc func rewindButton() {
        audioPlayer.stopPlaying()
        
        let isDoubleTap = (currentPhase.waitingPeriod! - 1) <= timerSeconds ? true:false
        
        if let newStage = searchForClosestGetReadyPhase(fromStart: true, doubeTap: isDoubleTap) {
            stageNumber = newStage
            pause()
            testView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
            runPhase()
        }
    }
    
    @objc func returnToMenu() {
        timer?.invalidate()
        audioPlayer.stopPlaying()
        navController.popViewController(animated: true)
    }
    
    func pause() {
        testView.pause.setImage(UIImage(named: "icons8-play"), for: .normal)
        isPaused = true
        timer?.invalidate()
        timer = nil
        audioPlayer.pauseAudio()
    }
    
    func restart() {
        testView.pause.setImage(UIImage(named: "icons8-pause"), for: .normal)
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
}

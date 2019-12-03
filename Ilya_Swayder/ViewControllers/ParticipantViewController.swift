//
//  ParticipantViewController.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 29/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class ParticipantViewController: UIViewController {
    
    var uniqueId: String = ""
    let studyProperties = Study.getStudy()
    var navCont:UINavigationController!
    var shouldContinueStudy:Bool!
    var shouldContinueStudyWith:String!

    
    @IBOutlet weak var singleLegStance: UIButton!
    
    @IBOutlet weak var tugReliability: UIButton!
    @IBOutlet weak var tug: UIButton!
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var participantID: UITextField!
    @IBOutlet weak var statusBar: StatusBarView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var slsCheckmark: UIImageView!
    @IBOutlet weak var tugCheckmark: UIImageView!
    @IBOutlet weak var tugReCheckmark: UIImageView!
    
    @IBAction func singleLegStanceAction(_ sender: UIButton) {
        
        if let trial = studyProperties.getTrialToRun(uniqueId: uniqueId, trialName: "Single Leg Stance") {
        
            runTrial(trialToRun: trial)
        }
    }
    
    @IBAction func tugAtcion(_ sender: UIButton) {
        
        if let trial = studyProperties.getTrialToRun(uniqueId: uniqueId, trialName: "TUG") {
    
        runTrial(trialToRun: trial)
        }
    }
    
    @IBAction func tugReliabilityAction(_ sender: UIButton) {
        
        if let trial = studyProperties.getTrialToRun(uniqueId: uniqueId, trialName: "TUG Realiability") {

        runTrial(trialToRun: trial)
        }
    }
    
    @IBAction func finishAction(_ sender: UIButton) {

        studyProperties.saveRawDataToCsv(participantId: uniqueId)
        setFInishedStatusToParticipant(ID: uniqueId)
        uniqueId = ""
        returnToStudy()
    }

    
    override func viewDidLoad() {
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureAvailableTrials()
        
    }
    
    func setupUI(){

        statusBar.name.text = studyProperties.researcherName
        statusBar.returnButtonOutlet.isHidden = false
        statusBar.returnButtonOutlet.addTarget(self, action: #selector(returnToStudy), for: .touchUpInside)
        self.statusBar.userImage.image = studyProperties.researcherImage
        self.statusBar.signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        
        if uniqueId == ""
        {
            buttonDisable(button: singleLegStance)
            buttonDisable(button: tug)
            buttonDisable(button: tugReliability)
            buttonDisable(button: finish)
        }
        
        self.participantID.delegate = self
        self.participantID.returnKeyType = .done
        self.participantID.autocorrectionType = .no
        
        checkmarkImage.isHidden = true
        slsCheckmark.isHidden = true
        tugCheckmark.isHidden = true
        tugReCheckmark.isHidden = true
        
        if shouldContinueStudy != nil {
            setIdToContinueStudy(uniqId: shouldContinueStudyWith)
        }
    }
    
    @objc func signOutAction() {
        
        studyProperties.saveStudyModelForReaercher()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        newViewController.signOutUser()
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func returnToStudy()
    {
        uniqueId = ""
        navCont.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureAvailableTrials()
    {
        if studyProperties.isTrialFinishedForID(trialName: "Single Leg Stance", ID: uniqueId) == FINISHED
        {
            buttonSetAsComplete(button: singleLegStance)
            slsCheckmark.isHidden = false
            
            if ((studyProperties.isTrialFinishedForID(trialName: "TUG", ID: uniqueId) == NOT_FINISHED) &&
               (studyProperties.isTrialFinishedForID(trialName: "TUG Realiability", ID: uniqueId) == NOT_FINISHED))
            {
                buttonEnable(button: tug)
                buttonEnable(button: tugReliability)
                
            }
            else if studyProperties.isTrialFinishedForID(trialName: "TUG", ID: uniqueId) == FINISHED
            {
                buttonSetAsComplete(button: tug)
                buttonDisable(button: tugReliability)
                tugCheckmark.isHidden = false
            }
            else if studyProperties.isTrialFinishedForID(trialName: "TUG Realiability", ID: uniqueId) == IN_PROGRESS
            {
                tugReliability.setTitle("Tug Reliability (1/2)", for: .normal)
                buttonEnable(button: tugReliability)
                buttonDisable(button: tug)
                tugReCheckmark.isHidden = true
            }
            else if studyProperties.isTrialFinishedForID(trialName: "TUG Realiability", ID: uniqueId) == FINISHED
            {
                tugReliability.setTitle("Tug Reliability", for: .normal)
                buttonSetAsComplete(button: tugReliability)
                buttonDisable(button: tug)
                tugReCheckmark.isHidden = false
            }
            
            if studyProperties.isStudyFinished(ID: uniqueId) == true
            {
                buttonEnable(button:finish)
            }
        }
    }
    
    func setFInishedStatusToParticipant(ID: String) {
        if let finishedStudy = studyProperties.getPariticantStudy(name: uniqueId) {
            studyProperties.removeParticipant(ID: uniqueId)
            studyProperties.setNewFinishedTrial(newFinishedTrial: finishedStudy)
        }
    }
    
    func buttonEnable(button:UIButton)
    {
        button.isEnabled = true
        button.alpha = 1
    }
    
    func buttonDisable(button:UIButton)
    {
        button.isEnabled = false
        button.alpha = 0.5
    }
    
    func buttonSetAsComplete(button:UIButton)
    {
        button.isEnabled = false
        button.alpha = 1
    }
    
    func buttonHide(button:UIButton) {
        
        button.isHidden = true
    }

    func buttonUnHide(button:UIButton) {
        
        button.isHidden = false
    }
    
    func returnDataFromTest(testName:String, rawDataSet:[rawData])
    {
        guard let participantIndex = studyProperties.getPariticantIndex(name: uniqueId) else {return}
        
        Study.listOfParticipants[participantIndex].numberOfDataFiles += rawDataSet.count
        
        if studyProperties.getPariticantStudy(name: uniqueId)?.SingleLegStance.getName() == testName {
            
            Study.listOfParticipants[participantIndex].SingleLegStance.setRawData(data: rawDataSet)
            Study.listOfParticipants[participantIndex].SingleLegStance.setTrialStatus(isFinishedStatus: FINISHED)

            slsCheckmark.isHidden = false
        }
        else if studyProperties.getPariticantStudy(name: uniqueId)?.TUG.getName() == testName {
            
            Study.listOfParticipants[participantIndex].TUG.setRawData(data: rawDataSet)
            Study.listOfParticipants[participantIndex].TUG.setTrialStatus(isFinishedStatus: FINISHED)
            tugCheckmark.isHidden = false
        }
        else if studyProperties.getPariticantStudy(name: uniqueId)?.TugReliability.getName() == testName {
            
            Study.listOfParticipants[participantIndex].TugReliability.setRawData(data: rawDataSet)
            Study.listOfParticipants[participantIndex].TugReliability.setTrialStatus(isFinishedStatus: FINISHED)
            tugReCheckmark.isHidden = false
        }
    }
    
    func runTrial(trialToRun: Trial) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        newViewController.currentTrial = trialToRun
        newViewController.clearRawData()
        newViewController.navController = navCont
        
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
}

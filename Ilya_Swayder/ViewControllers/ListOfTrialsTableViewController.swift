//
//  ListOfTrialsTableViewController.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 01/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class ListOfTrialsTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    let studyProperties = Study.getStudy()
    var navController:UINavigationController!
    
    @IBOutlet weak var statusBar: StatusBarView!
    
    @IBOutlet weak var listOfTrials: UITableView!
    override func viewDidLoad() {
        
        statusBar.name.text = studyProperties.researcherName
        statusBar.returnButtonOutlet.isHidden = false
        statusBar.returnButtonOutlet.addTarget(self, action: #selector(returnToStudy), for: .touchUpInside)
        self.statusBar.userImage.image = studyProperties.researcherImage
        self.statusBar.signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        self.listOfTrials.dataSource = self
        
    
    }
    
    @objc func signOutAction() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        newViewController.signOutUser()
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func returnToStudy()
    {
        navController.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Study.listOfParticipants.count + Study.listOfParticipantsTrialEnds.count + 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listOfTrials.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = listOfTrials.dequeueReusableCell(withIdentifier: "headerCell") as! ListOfTrialsHeaderCell
            
            cell.populateCell(label: "In Progress", numberOfTrials: String(Study.listOfParticipants.count))
            
            return cell
        }
        else if indexPath.row < (Study.listOfParticipants.count + 1) {
            
            let cell = listOfTrials.dequeueReusableCell(withIdentifier: "trialCell") as! ListOfTrialsContentCell
            
            let participantStudy = Study.listOfParticipants[indexPath.row - 1]
            
            let id = participantStudy.getName()!
            
            cell.populateCell(timeAndDate: participantStudy.time, ID: id, trialsLabels: getFinishedTrialsAsString(study: participantStudy), shouldBePresseble: true, isSynced: participantStudy.isSynced)
            
            return cell
        }
        else if (indexPath.row == Study.listOfParticipants.count + 1) || (indexPath.row == 1)
        {
            let cell = listOfTrials.dequeueReusableCell(withIdentifier: "headerCell") as! ListOfTrialsHeaderCell
            
            cell.populateCell(label: "Completed", numberOfTrials: String(Study.listOfParticipantsTrialEnds.count))
            
            return cell
        }
        else
        {
            let cell = listOfTrials.dequeueReusableCell(withIdentifier: "trialCell") as! ListOfTrialsContentCell
            
            let participantStudy = Study.listOfParticipantsTrialEnds[indexPath.row - Study.listOfParticipants.count - 2]
            
            let id = participantStudy.getName()!

            cell.populateCell(timeAndDate: participantStudy.time, ID: id, trialsLabels: getFinishedTrialsAsString(study: participantStudy), shouldBePresseble: false, isSynced: participantStudy.isSynced)
        
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntry(row: indexPath.row)
            
            listOfTrials.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let row = indexPath.row
        
        if row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if row <= (Study.listOfParticipants.count) {
            let cell = tableView.cellForRow(at: indexPath) as! ListOfTrialsContentCell
            setViewControllerToContinue(uniqueId: cell.uniqueIdLabel.text!)
        }
        else if row == (Study.listOfParticipants.count + 1) {
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func getFinishedTrialsAsString(study:StudyData) -> String {
        
        var finishedTrials:String = ""
        
        if let sls = study.SingleLegStance{
            finishedTrials += sls.isSpecificTrialFinished() == FINISHED ? "SLS": ""
        }
        if let tug = study.TUG {
            finishedTrials += tug.isSpecificTrialFinished() == FINISHED ?  ", TUG": ""
        }
        if let tugRe = study.TugReliability {
            finishedTrials += tugRe.isSpecificTrialFinished() == FINISHED ? ", TUG Reliability": ""
        }
        
        return finishedTrials
    }
    
    func deleteEntry(row: Int) {
        
        if row == 0 {
            return
        }
        else if row <= (Study.listOfParticipants.count) {
            
            let entryToDelete = row - 1
            
            Study.listOfParticipants.remove(at: entryToDelete)
        }
        else {
            let entryToDelete = (row - 2 - (Study.listOfParticipants.count))
            
            Study.listOfParticipantsTrialEnds.remove(at: entryToDelete)
        }
    }
    
    func setViewControllerToContinue(uniqueId:String){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ParticipantViewController") as! ParticipantViewController
        newViewController.navCont = navController
        newViewController.shouldContinueStudy = true
        newViewController.shouldContinueStudyWith = uniqueId
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

}

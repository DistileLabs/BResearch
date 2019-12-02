//
//  StudyViewController.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 17/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class StudyViewController: UIViewController {
    
    let studyProperties = Study.getStudy()
    let googleDriveService = GTLRDriveService()
    let projectFileManager = ProjectFileManager.getFileManager()
    let fireBaseStorage = FireBaseStorage()
    var navController:UINavigationController!
    
    @IBOutlet var statusBar: StatusBarView!
    
    @IBOutlet weak var loadProtolOutlet: UIButton!
    @IBOutlet weak var syncOutlet: UIButton!
    @IBOutlet weak var syncInProcess: UIActivityIndicatorView!
    @IBOutlet weak var lastSyncLabel: UILabel!
    
    @IBAction func startNewTrial(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ParticipantViewController") as! ParticipantViewController
        newViewController.navCont = navController
        self.navigationController?.pushViewController(newViewController, animated: true)
        //self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func listOfTrials(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ListOfTrialsTableViewController") as! ListOfTrialsTableViewController
        newViewController.navController = navController
        self.navController.pushViewController(newViewController, animated: true)
    }
    @IBAction func loadNewProtocol(_ sender: Any) {
        
        openDocumentPicker()
    }
    
    @IBAction func sync(_ sender: Any) {
        
        startSyncView()
        
        let whoToSync = studyProperties.getParticipantsToSync()
        
        DispatchQueue.global(qos: .userInitiated).async {
        
            let syncGroup = DispatchGroup()
            
            var progressCounter:Int = 1
            let researcherName = self.studyProperties.researcherName
            for single in whoToSync {
                
                let index = self.studyProperties.getFinishedStudyParticipantIndex(name: single)
                let numOfFiles = Study.listOfParticipantsTrialEnds[index!].numberOfDataFiles
                
                DispatchQueue.main.sync {
                    //self.syncOutlet.setTitle("Synced \(progressCounter)/\(whoToSync.count)", for: .normal)
                    self.lastSyncLabel.text = "Syncing \(progressCounter)/\(whoToSync.count)"
                }
              
                let filtered = Study.listOfParticipantsFromOnlineStorage?.filter({ $0 == single })
                if filtered?.isEmpty == false {
                    syncGroup.enter()
                    self.fireBaseStorage.deleteParticipant(name: single) {
                        syncGroup.leave()
                    }
                    syncGroup.wait()
                }
                
                syncGroup.enter()
                
                let participantDir = self.projectFileManager.getParticipantDir(reasercherName: researcherName, participantName: single)
                
                self.fireBaseStorage.uploadTrial(researcheName: researcherName, partifipantName: single, uploadFromURL: participantDir!, numberOfFiles: numOfFiles) { (isFinished) in
                    if isFinished != false {
                        Study.listOfParticipantsTrialEnds[index!].isSynced = true
                    } else {
                        self.stopSyncView()
                        return
                    }
                    
                    syncGroup.leave()
                    
                }
                
                progressCounter += 1
                syncGroup.wait()
            }
            
            DispatchQueue.main.async {

                self.stopSyncView()
                self.studyProperties.setSyncTime()
                self.setSyncTimeLabel()
            }
        }
    }
    
//    @IBAction func sync(_ sender: Any) {
//
//        startSyncView()
//
//        let (whoToSync, numOfFiles) = studyProperties.getParticipantsToSync()
//
//        projectFileManager.syncResearcher(name: studyProperties.researcherName, participants: whoToSync, numberOfFilesToSync: numOfFiles, completion: {(finish) in
//            self.stopSyncView()
//            self.studyProperties.setSyncTime()
//            self.setSyncTimeLabel()
//        })
//    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

    }
    
    
    override func viewDidLoad() {
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI()
    {
        self.setSyncTimeLabel()
        self.statusBar.name.text = studyProperties.researcherName
        self.statusBar.userImage.image = studyProperties.researcherImage
        self.statusBar.signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        
        if Reachability.isConnectedToNetwork() == false {
            loadProtolOutlet.isEnabled = false
            loadProtolOutlet.alpha = 0.5
            syncOutlet.isEnabled = false
            syncOutlet.alpha = 0.5
        }
        else {
            loadProtolOutlet.isEnabled = false
            loadProtolOutlet.alpha = 0.5
            syncOutlet.isEnabled = true
            syncOutlet.alpha = 1
        }
    }
    
    @objc func signOutAction() {
        
        let dest = navController.viewControllers[0] as? SignInViewController
        dest?.signOutUser()
        navController.popViewController(animated: true)
    }
    
    func startSyncView() {
        
        syncInProcess.startAnimating()
        syncOutlet.isEnabled = false
        syncOutlet.setTitle("", for: .normal)
        //lastSyncLabel.isHidden = true
    }
    
    func stopSyncView() {
        self.syncInProcess.stopAnimating()
        syncOutlet.isEnabled = true
        syncOutlet.setTitle("Sync", for: .normal)
        //lastSyncLabel.isHidden = false
    }
    
    func setSyncTimeLabel() {
        lastSyncLabel.text = "Last: \(studyProperties.lasSync)"
    }
}

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
    
    @IBOutlet var statusBar: StatusBarView!
    
    @IBOutlet weak var loadProtolOutlet: UIButton!
    @IBOutlet weak var syncOutlet: UIButton!
    
    @IBAction func startNewTrial(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NavController")
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func listOfTrials(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ListOfTrialsTableViewController")
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func loadNewProtocol(_ sender: Any) {
        
        openDocumentPicker()
    }
    
    @IBAction func sync(_ sender: Any) {
        
    }
    
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
        self.statusBar.name.text = studyProperties.researcherName
        self.statusBar.signOutButton.setBackgroundImage(studyProperties.researcherImage, for: .normal)
        self.statusBar.signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        
        if Reachability.isConnectedToNetwork() == false {
            loadProtolOutlet.isEnabled = false
            loadProtolOutlet.alpha = 0.5
            syncOutlet.isEnabled = false
            syncOutlet.alpha = 0.5
        }
        
    }
    
    @objc func signOutAction() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        newViewController.signOutUser()
        self.present(newViewController, animated: true, completion: nil)
    }

}

//
//  SignInViewController.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 16/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher


class SignInViewController: UIViewController,UINavigationControllerDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var continueToModelOutlet: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var userSigned:GIDGoogleUser?
    var signInModel:SignInModel?
    let studyProperties:Study = Study.getStudy()
    let projectFileManager = ProjectFileManager.getFileManager()
    fileprivate let service = GTLRDriveService()
    var drive:ATGoogleDrive = ATGoogleDrive.getDrive()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive,kGTLRAuthScopeDriveFile]
        
//        signInModel = projectFileManager.readDataUserDefaults(key:"UserCoreData") as? SignInModel
//        if signInModel == nil { signInModel = SignInModel()}
        if Reachability.isConnectedToNetwork() != true {
            studyProperties.reloadList()
            continueToStudy()
        }
        
       if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
        self.spinner.startAnimating()//self.spinnerAction(shouldSpin: true)
        GIDSignIn.sharedInstance()?.signInSilently()
       }
       else {
            addGoogleSignInButton()
       }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     
        if user == nil {
            studyProperties.reloadList()
            if studyProperties.researcherName != "" {
                continueToStudy()
            }
            else {
                noConnection()
            }
        }
        
        spinner.startAnimating()//self.spinnerAction(shouldSpin: true)
        service.authorizer = user.authentication.fetcherAuthorizer()
        drive.addDriveService(serv: service)
        userSigned = user
 
        studyProperties.reloadList()
        
        if studyProperties.researcherEmail != user.profile.email
        {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
 
                URLSession.shared.dataTask(with: user.profile.imageURL(withDimension: 100)) { (data, response, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    let newGivenName = self.userSigned?.profile?.givenName ?? ""
                    let newFamilyName =  self.userSigned?.profile?.familyName ?? ""
                    let newEmail = self.userSigned?.profile.email
                    let newImage = UIImage(data: data!)
                    self.studyProperties.studyParamsSet(newResearcherName: newGivenName + " " + newFamilyName , image: newImage, newResearcherEmail: newEmail!)

                    group.leave()
                    
                }.resume()
            }
            group.notify(queue: .main) {
                self.continueToStudy()
            }
        }
        else
        {
            self.continueToStudy()
        }
    }
    
    func continueToStudy() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "StudyViewController") as! StudyViewController
        newViewController.navController = self.navigationController
        self.spinner.stopAnimating()//self.spinnerAction(shouldSpin: true)
        self.navigationController?.pushViewController(newViewController, animated: true)

    }
    
    func noConnection() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoConnection")
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func addGoogleSignInButton()
    {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width - 200 , height: 100))
        
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }
    
    func signOutUser() {
        GIDSignIn.sharedInstance()?.signOut()
        studyProperties.saveStudyModelForReaercher()
        addGoogleSignInButton()
    }
}



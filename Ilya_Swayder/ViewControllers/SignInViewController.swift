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


class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var fuckingImage: UIImageView!
    @IBOutlet weak var continueToModelOutlet: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var userSigned:GIDGoogleUser?
    var signInModel:SignInModel?
    let study:Study = Study.getStudy()
    let projectFileManager = ProjectFileManager.getFileManager()
    fileprivate let service = GTLRDriveService()
    var drive:ATGoogleDrive = ATGoogleDrive.getDrive()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive,kGTLRAuthScopeDriveFile]
        
        signInModel = projectFileManager.readDataUserDefaults(key:"UserCoreData") as? SignInModel
        if signInModel == nil { signInModel = SignInModel()}
        
       if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
            
        GIDSignIn.sharedInstance()?.signInSilently()
       }
        
        if Reachability.isConnectedToNetwork() != true {
            continueToStudy()
        }
        
        addGoogleSignInButton()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     
        service.authorizer = user.authentication.fetcherAuthorizer()
        drive.addDriveService(serv: service)
        self.spinnerAction(shouldSpin: true)
        userSigned = user
        
        if user != nil
        {
            if signInModel!.givenName != user.profile.givenName
            {
                URLSession.shared.dataTask(with: user.profile.imageURL(withDimension: 100)) { (data, response, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.projectFileManager.saveImageToDocumentDirectory(image: UIImage(data: data!)!, userName: user.profile.familyName, folderName: "Utility", imageName: "userGoogleImage.png")
                        self.signInModel!.saveSignedInUser(newUser: user)

                        self.projectFileManager.writeDataUserDefaults(dataToWrite: self.signInModel!, key: "UserCoreData")
                        self.fuckingImage.image = self.signInModel!.userImage
                        self.spinnerAction(shouldSpin: false)
                        self.continueToStudy()
                    }
                }.resume()
            }
            else
            {
                self.spinnerAction(shouldSpin: false)
                self.continueToStudy()
            }
        }
    }
    
    func continueToStudy() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "StudyViewController") as! StudyViewController
  
        study.researcherImage = signInModel!.userImage

        study.researcherName = signInModel!.givenName + " " + signInModel!.lastName
        
        study.reloadList()
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func addGoogleSignInButton()
    {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 48))
        
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }

    func spinnerAction(shouldSpin status: Bool) {
        if status == true {
            
            spinner.isHidden = false
            spinner.startAnimating()
        }
        else
        {
            spinner.isHidden = true
            spinner.stopAnimating()
        }
    }
    
    func signOutUser() {
        GIDSignIn.sharedInstance()?.signOut()
        self.signInModel?.clearUser()
    }
}



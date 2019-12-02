//
//  AppDelegate.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 10/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let study:Study = Study.getStudy()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // Configure google sign-in
        GIDSignIn.sharedInstance().clientID = "244775951103-scr8mh4c5hrqiv55q16pt2nehr49vh61.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        // Perform any operations when the user disconnects from app here.
        print("User has disconnected")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url, sourceApplication: sourceApplication, annotation: annotation))!
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        study.saveStudyModelForReaercher()
        UserDefaults.standard.set(cycleNumber, forKey: "cycleNumber")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //study.saveStudyModelForReaercher()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        cycleNumber = UserDefaults.standard.integer(forKey: "cycleNumber")
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}


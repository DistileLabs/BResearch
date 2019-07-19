//
//  SignInModel.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 03/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import GoogleSignIn

class SignInModel: NSObject, NSCoding {
    
    struct Keys {
        
        static let givenName = "givenName"
        static let lastName = "lastName"
        static let userImage = "userImage"
    }
    
    var givenName: String = ""
    var lastName: String = "Default"
    var userImage: UIImage?
    let projectFileManager: ProjectFileManager = ProjectFileManager.getFileManager()
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(givenName,forKey: Keys.givenName)
        aCoder.encode(lastName,forKey: Keys.lastName)
    }
    
    override init() {
        // Do nothing
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let givenNameObject = aDecoder.decodeObject(forKey: Keys.givenName) as? String {
            givenName = givenNameObject
        }
        
        if let lastNameObject = aDecoder.decodeObject(forKey: Keys.lastName) as? String {
            lastName = lastNameObject
            
            userImage = projectFileManager.getUserImage(userName: lastName)
        }
    }
    
    func saveSignedInUser(newUser: GIDGoogleUser?) {
        
        guard newUser != nil else { return }
        
        givenName = newUser!.profile.givenName
        lastName = newUser!.profile.familyName
        userImage = projectFileManager.getUserImage(userName: lastName)

    }

    func clearUser() {
        
        givenName = ""
        lastName = ""
        userImage = nil
    }
    
    func isUserSignedIn() -> Bool {
        
        if givenName != ""
        {
            return true
        }
        
        return false
    }
}

//
//  StudyModel.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 18/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class Study{

    struct Keys {
        
        static let listOfParticipants = "listOfParticipants"
    }
    
    static var listOfParticipants:[StudyData] = []
    static var listOfParticipantsTrialEnds:[StudyData] = []
    static var listOfParticipantsFromOnlineStorage:[String]?
    let projectFileManager = ProjectFileManager.getFileManager()
    var lasSync:String = ""
    var researcherName: String = ""
    var researcherImage: UIImage?
    var researcherEmail:String = ""
    
    // Singletone
    static var studyProperties: Study = {

        return Study()
    }()
    
    private init() {
        // Private
    }
    
    class func getStudy() -> Study {

        return studyProperties
    }
    
    func saveStudyModelForReaercher() {
        projectFileManager.writeDataUserDefaults(dataToWrite: researcherName, key: "SavedReasercher")
        projectFileManager.writeDataUserDefaults(dataToWrite: Study.listOfParticipants, key: researcherName)
        projectFileManager.writeDataUserDefaults(dataToWrite: Study.listOfParticipantsTrialEnds, key: researcherName + "Finished")
        projectFileManager.writeDataUserDefaults(dataToWrite: lasSync, key: researcherName + "Sync")
        projectFileManager.writeDataUserDefaults(dataToWrite: researcherEmail, key: researcherName + "Email")
        
        self.projectFileManager.saveImageToDocumentDirectory(image: researcherImage, userName: researcherName, folderName: "Utility", imageName: "userGoogleImage.png")
    }
    
    func reloadList() {
        if let lastResearcher = projectFileManager.readDataUserDefaults(key: "SavedReasercher") as? String{
            researcherName = lastResearcher
        }
        if let tryToReload = projectFileManager.readDataUserDefaults(key: researcherName) as? [StudyData] {
            Study.listOfParticipants = tryToReload
        }
        if let tryToReload = projectFileManager.readDataUserDefaults(key: researcherName + "Finished") as? [StudyData] {
            Study.listOfParticipantsTrialEnds = tryToReload
        }
        if let lastTimeSynced = projectFileManager.readDataUserDefaults(key: researcherName + "Sync") as? String{
            lasSync = lastTimeSynced
        }

        if let lastResearcherEmail = projectFileManager.readDataUserDefaults(key: researcherName + "Email") as? String{
            researcherEmail = lastResearcherEmail
        }

        if let lastResearcherImage = projectFileManager.getUserImage(userName: researcherName) {
            researcherImage = lastResearcherImage
        }
    }
    
    func reloadParticipantsData() {
        if let tryToReload = projectFileManager.readDataUserDefaults(key: researcherName) as? [StudyData] {
            Study.listOfParticipants = tryToReload
        }
        if let tryToReload = projectFileManager.readDataUserDefaults(key: researcherName + "Finished") as? [StudyData] {
            Study.listOfParticipantsTrialEnds = tryToReload
        }
        if let lastTimeSynced = projectFileManager.readDataUserDefaults(key: researcherName + "Sync") as? String{
            lasSync = lastTimeSynced
        }
    }
    
    func studyParamsSet(newResearcherName:String, image: UIImage?, newResearcherEmail:String) {
        resetStudyForNewUse()
        researcherImage = image
        researcherName = newResearcherName
        researcherEmail = newResearcherEmail
        
        reloadParticipantsData()
    }
    
    private func resetStudyForNewUse() {

        researcherImage = nil
        researcherName = ""
        Study.listOfParticipants = []
        Study.listOfParticipantsTrialEnds = []
        
    }
}


//
//  Study+Extention.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 30/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation


extension Study {
    
    func addParticipant(partcipantId: String) -> Bool {

        for  participant in Study.listOfParticipants {
            
            guard partcipantId != participant.getName() else { return false }
        }
        
        for  participant in Study.listOfParticipantsTrialEnds {
            
            guard partcipantId != participant.getName() else { return false }
        }
        
        if let onlineParticipanits = Study.listOfParticipantsFromOnlineStorage {
            
            for participant in onlineParticipanits {
                
                guard partcipantId != participant else { return false }
            }
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm \n dd LLL yy"
 
        Study.listOfParticipants.append(StudyData(newParticipant:partcipantId, timeAndDate:formatter.string(from: Date()), synced:false))
        
        return true
    }
    
    func isTrialFinishedForID(trialName:String, ID: String) -> Int {
        
        guard let currentParticipant = getPariticantStudy(name: ID) else { return NOT_FINISHED }
        
        return currentParticipant.isTrialFinished(trialName: trialName)
    }
    
    func isStudyFinished(ID: String) -> Bool
    {
        guard let currentParticipant = getPariticantStudy(name: ID) else { return false }
        
        return currentParticipant.isAllMandatoryTrialFinished()
    }
    
    func startTrial(trialName:String, ID: String) -> Bool {
        
        guard let currentParticipant = getPariticantStudy(name: ID) else { return false } // ADD
        
        do {
            try currentParticipant.runTrials(trialName: trialName)
        } catch  StudyError.trialNameNotExists(requstedTrial: let errorTrialName) {
            print("The following trial does not exist %s",errorTrialName)
            
            return false
            
        } catch {
            NSLog("Shit happens, trial name %s", trialName)
            
            return false
        }
        
        return true
    }
    
    func removeParticipant(ID: String) {
        
        guard let currentParticipant = getPariticantStudy(name: ID) else { return }
        
        let index = Study.listOfParticipants.firstIndex{$0.getName() == currentParticipant.getName()}
        
        Study.listOfParticipants.remove(at: index!)
    }
    
    func getPariticantStudy(name: String) -> StudyData? {
        
        let study = Study.listOfParticipants.filter{$0.getName() == name}
        
        guard study.isEmpty == false else { return nil}
        
        return study[0]
    }
    
    func setNewFinishedTrial(newFinishedTrial: StudyData) {
        
        Study.listOfParticipantsTrialEnds.append(newFinishedTrial)

    }
    
    func getPariticantIndex(name: String) -> Int? {
        
        let index = Study.listOfParticipants.firstIndex {$0.getName() == name}
        
        return index
    }
    
    func getFinishedStudyParticipantIndex(name:String) -> Int? {
        
        return Study.listOfParticipantsTrialEnds.firstIndex {$0.getName() == name}
    }
    
    func saveRawDataToCsv(participantId:String) {
        
        if let singleStudy = getPariticantStudy(name: participantId) {
            var fileNumber:Int = 1
            for slsData in singleStudy.SingleLegStance.getRawData()! {
                
                projectFileManager.writeTrialCsvDataToDisc(reasercherName: researcherName, participantName: singleStudy.getName()!, trialName: "SLS", stepName: "sls\(fileNumber)_\(String(slsData.stageNumber!))", data: slsData.stageData!)
                
                fileNumber += 1
            }
            
            singleStudy.SingleLegStance.eraseRawDate()
            
            if singleStudy.TUG.getRawData() != nil {
                var fileNumber:Int = 1
                for tugData in singleStudy.TUG.getRawData()! {
                    
                    projectFileManager.writeTrialCsvDataToDisc(reasercherName: researcherName, participantName: singleStudy.getName()!, trialName: "TUG", stepName: "Tug\(fileNumber)_\(String(tugData.stageNumber!))", data: tugData.stageData!)
                    
                    fileNumber += 1
                }
                
                singleStudy.TUG.eraseRawDate()
            }
            
            if singleStudy.TugReliability.getRawData() != nil {
                let phase = singleStudy.TugReliability.currentPhase
                var fileNumber:Int = 1
                for tugRData in singleStudy.TugReliability.getRawData()! {
                    
                    projectFileManager.writeTrialCsvDataToDisc(reasercherName: researcherName, participantName: singleStudy.getName()!, trialName: "TUG_Realibility", stepName: "Tug\(fileNumber)_Phase\(phase)_Stage\(String(tugRData.stageNumber!))", data: tugRData.stageData!)
                    fileNumber += 1
                }
                singleStudy.TugReliability.eraseRawDate()
            }
        }
    }
    
    func getParticipantsToSync() -> [String] {
        var nameArray = [String]()
   
        for study in Study.listOfParticipantsTrialEnds {
            
            if study.isSynced == false {
                nameArray.append(study.getName()!)
            }
        }
        return nameArray
    }
    
    func setSyncTime() {
        lasSync = setCurrentTime()
    }
    
    private func setCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm, dd LLL yy"
        
        return formatter.string(from: Date())
    }
    
    func getTrialToRun(uniqueId:String, trialName:String) -> Trial? {
        
        if let dataForId = getPariticantStudy(name: uniqueId) {
            
            switch trialName {
            case dataForId.SingleLegStance.getName():
                return dataForId.SingleLegStance
            case dataForId.TUG.getName():
                return dataForId.TUG
            case dataForId.TugReliability.getName():
                return dataForId.TugReliability
            default:
                return nil
            }
        }
        
        return nil
    }
}


//
//  FireBaseStorage.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 01/12/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import FirebaseStorage

class FireBaseStorage {
    
    let storageRef = Storage.storage().reference().child(K.FirebaseStorage.elderlySurvey)
    let dispatchGroup = DispatchGroup()
    var isFinished:Bool = true
    
    func uploadTrial(partifipantName: String, uploadFromURL:URL, numberOfFiles:Int, completion: @escaping(Bool)-> ()) {
        
        let participantStorageRef = storageRef.child(partifipantName)
        if let dirContents = try? FileManager.default.contentsOfDirectory(at: uploadFromURL, includingPropertiesForKeys: nil) {
            
            
            for dir in dirContents {
                let trialStorageRef = participantStorageRef.child(dir.lastPathComponent)
                if let trialFiles = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) {
                    
                    for file in trialFiles {
                        dispatchGroup.enter()
                        
                        let fileStorageRef = trialStorageRef.child(file.lastPathComponent)
                        fileStorageRef.putFile(from: file, metadata: nil) { (metadData, error) in
                            if let e = error {
                                print(e.localizedDescription)
                                self.isFinished = false
                                completion(self.isFinished)
                            }
                            self.dispatchGroup.leave()
                        }
                        dispatchGroup.wait()
                    }
                }
            }
        }
        completion(isFinished)
    }
    
    func listFiles(from child:String, completion:@escaping([String]?)->()) {

        let storageRef = Storage.storage().reference().child(child)
        var listOfNames:[String] = []
        
        storageRef.listAll { (result, error) in
            if let e = error {
                print(e.localizedDescription)
                completion(nil)
            }
            for item in result.prefixes {
                let name = item.name.split(separator: "/")
                
                listOfNames.append(String(name.last!))
                
            }
            completion(listOfNames)
        }
    }
    
    func deleteParticipant(name: String, completion:@escaping()->()) {
        let participantRef = storageRef.child(name)
        
        participantRef.delete { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
            completion()
        }
    }
}

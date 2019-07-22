//
//  FileManagerModel.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 07/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit
import GoogleAPIClientForREST

class ProjectFileManager {
    
    let drive = ATGoogleDrive.getDrive()
    var drives = [Drive]()
    // Singletone
    private static var projectFileManager: ProjectFileManager = {
        
        return ProjectFileManager()
    }()
    
    private init() {
        // Private
    }
    
    class func getFileManager() -> ProjectFileManager {
        return projectFileManager
    }
    
    func getUserImage(userName: String) -> UIImage? {
        
        return getImageFromDocumentDirectory(userName: userName, folderName: "Utility", "userGoogleImage.png")
    }
    
    func writeTrialCsvDataToDisc(reasercherName:String, participantName:String, trialName:String, stepName: String, data: String) {

        if let participantDir = getParticipantDir(reasercherName: reasercherName, participantName: participantName) {
            
            if let trialDir = setDirectory(dirName: trialName, toPath: participantDir) {
                
                let finalUrl = trialDir.appendingPathComponent("\(stepName).csv")
                
                do {
                    try data.write(to: finalUrl, atomically: true, encoding: .utf8)
                }catch {
                    print("Write of \(reasercherName)_\(participantName)_\(trialName)_\(stepName) FAILED")
                }
            }
        }
    }

    func getContentOfUserDir(reasercherName:String, participantName:String) -> [URL]? {
        if let participantDir = getParticipantDir(reasercherName: reasercherName, participantName: participantName) {
            
            let uploadGroup = DispatchGroup()
            if let dirContents = try? FileManager.default.contentsOfDirectory(at: participantDir, includingPropertiesForKeys: nil) {
                
                for dir in dirContents {
                    
                   if let trialContent = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) {
                    
                    for file in trialContent {
                            drive.uploadFile("Swayder", filePath: file.path, MIMEType: "text/csv", onCompleted: ({ (result, error) in
                                if error != nil {
                                    print(error as Any)
                                }
                                else
                                {
                                    print(result as Any)
                                }
                            }))

                        }

                    }
                }
                print(dirContents)
                
                return dirContents
            }
        }
        return nil
    }
    
    func getParticipantDir(reasercherName:String, participantName:String) -> URL? {
        if let appDir = setDirectory(dirName: "Swayder") {
        
            if let reasercherDir = setDirectory(dirName: reasercherName, toPath: appDir) {
        
                if let participantDir = setDirectory(dirName: participantName, toPath: reasercherDir) {
                    
                    return participantDir
                }
            }
        }
        return nil
    }

    
    func saveImageToDocumentDirectory(image: UIImage, userName:String, folderName: String, imageName: String ) {
        if let data = image.pngData() {
            
            if let userDir = setDirectory(dirName: userName) {
                
                if let folderName = setDirectory(dirName: folderName, toPath: userDir) {
                    
                    let fileName = folderName.appendingPathComponent("\(imageName)")
                    try? data.write(to: fileName)
                }
            }
        }
    }
    

    func getImageFromDocumentDirectory(userName:String, folderName: String, _ path: String) -> UIImage? {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let userUrl = documentsURL.appendingPathComponent(userName)
 
        let userFolderName = userUrl.appendingPathComponent(folderName)
        
        let fileUrl = userFolderName.appendingPathComponent(path)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            //Get Image And upload in server
            print("fileURL.path \(fileUrl.path)")
            
            do{
                let data = try Data.init(contentsOf: fileUrl)
                let image = UIImage(data: data)
                return image
            }catch{
                print("error getting image")
            }
        } else {
            print("No image in directory")
        }
        
        return nil
    }
    
    func writeDataUserDefaults(dataToWrite: Any, key:String){
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: dataToWrite, requiringSecureCoding: false) {
   
            UserDefaults.standard.set(data, forKey: key)
        }
   
    }
    
    func readDataUserDefaults(key:String) -> Any?{
        
        if let data = UserDefaults.standard.data(forKey: key) {
            
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        }
        
        return nil
    }
    
    private func setDirectory(dirName: String) -> URL?{
        
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
          return addDirectory(dirName: dirName, toPath: documentsDirectory)
        }
        return nil
    }
    
    private func setDirectory(dirName: String, toPath: URL) -> URL?{

           return addDirectory(dirName: dirName, toPath: toPath)

        }

    private func addDirectory(dirName: String, toPath: URL) -> URL? {
    
        let folderUrl = toPath.appendingPathComponent(dirName)
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: folderUrl.path) {
            
            do {
                try fileManager.createDirectory(atPath: folderUrl.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return folderUrl
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func saveCsvFile(data:String, userName:String, csvFolderName: String, csvName: String) {
        
        if let userDir = setDirectory(dirName: userName) {
            
            if let folderName = setDirectory(dirName: csvFolderName, toPath: userDir) {
                
                let fileName = folderName.appendingPathComponent("\(csvName).csv")
                
                //try? data.write(to: fileName)
            }
        }
    }
    
    
}

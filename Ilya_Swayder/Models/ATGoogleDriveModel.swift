//
//  ATGoogleDriveModel.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 14/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

enum GDriveError: Error {
    case NoDataAtPath
}

class ATGoogleDrive {
    
    private var service: GTLRDriveService!
    
//    init(_ service: GTLRDriveService) {
//        self.service = service
//    }
//
//    init() {
//        // SHIT
//    }
    
    private static var googleDrive: ATGoogleDrive = {
        
        let drive = ATGoogleDrive()
        
        return drive
    }()
    
    private init() {
        // Private
    }
    
    class func getDrive() -> ATGoogleDrive {
        return googleDrive
    }
    
    func addDriveService(serv: GTLRDriveService?) {
        service = serv
        service.shouldFetchNextPages = true
    }
    
    
    public func listFilesInFolder(_ folder: String, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        search(folder) { (folderID, error) in
            guard let ID = folderID else {
                onCompleted(nil, error)
                return
            }
            self.listFiles(ID.identifier!, onCompleted: onCompleted)
        }
    }
    
    private func listFiles(_ folderID: String, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 5000
        query.q = "'\(folderID)' in parents"
        
        service.executeQuery(query) { (ticket, result, error) in
            onCompleted(result as? GTLRDrive_FileList, error)
        }
    }
  
// ORG
//    public func uploadFile(_ folderName: String, filePath: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
//
//        search(folderName) { (folder, error) in
//
//            if let ID = folder {
//                self.upload(folder!.identifier!, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
//            } else {
//                self.createFolder(folderName, onCompleted: { (folderID, error) in
//                    guard let ID = folder else {
//                        onCompleted?(nil, error)
//                        return
//                    }
//                    self.upload(folder!.identifier!, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
//                })
//            }
//        }
//    }
    
    public func uploadFile(_ folderName: String, filePath: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
    
        self.upload(folderName, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
    }
    
    public func  getTrialPath(participantDirId: String, trialName:String, onCompleted: ((String?, Error?) -> ())?) {
        
        self.getDirId(trialName, parentsId: participantDirId, onCompleted: { (finalId, error) in
            onCompleted?(finalId?.identifier,error)
            
            return
        })

    }
    
    public func getParticipantPath(reasercherName: String, participantName:String, onCompleted: ((String?, Error?) -> ())?) {
        
        getDirId("Swayder", parentsId: nil, onCompleted: { (trialFolderId, error) in
            if error != nil {
                print("Swayder dir_\(String(describing: error))")
                return
            }
            
            self.getDirId(reasercherName, parentsId: trialFolderId!.identifier, onCompleted: { (reasercherFolderId, error) in
                
                if error != nil {
                    print("Reasercher dir_\(String(describing: error))")
                    return
                }
                
                self.getDirId(participantName, parentsId: reasercherFolderId!.identifier, onCompleted: { (participantFolderId, error) in
                    if error != nil {
                        print("Participant dir_\(String(describing: error))")
                        return
                    }
                    onCompleted?(participantFolderId?.identifier,error)
                    
                    return
                })
            })
        })
    }
    
    

    
    func upload(_ parentID: String, path: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
        
        guard let data = FileManager.default.contents(atPath: path) else {
            onCompleted?(nil, GDriveError.NoDataAtPath)
            return
        }
        
        let file = GTLRDrive_File()
        file.name = path.components(separatedBy: "/").last
        file.parents = [parentID]
        
        let uploadParams = GTLRUploadParameters.init(data: data, mimeType: MIMEType)
        uploadParams.shouldUploadWithSingleRequest = true
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
        query.fields = "id"
        
        self.service.executeQuery(query, completionHandler: { (ticket, file, error) in
            onCompleted?((file as? GTLRDrive_File)?.identifier, error)
        })
    }
    
    public func download(_ fileID: String, onCompleted: @escaping (Data?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { (ticket, file, error) in
            onCompleted((file as? GTLRDataObject)?.data, error)
        }
    }
    
    public func search(_ fileName: String, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 4
        query.q = "mimeType='application/vnd.google-apps.folder' and name contains '\(fileName)'"
        
        service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files?.first, error)
        }
    }
    
    public func search(_ fileName: String,parents: String?, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 4
        query.q = "mimeType='application/vnd.google-apps.folder' and name contains '\(fileName)'"
        query.fields = "files(id,name,parents)"
        print(fileName)
        service.executeQuery(query) { (ticket, results, error) in
            
            if parents != nil {
                let parseResutls = (results as? GTLRDrive_FileList)?.files
                
                for singleResult in parseResutls! {
                    
                    for parent in singleResult.parents! {
                        
                        if parents! == parent {
                            onCompleted(singleResult, error)
                            break;
                        }
                    }
                }
            }
            onCompleted((results as? GTLRDrive_FileList)?.files?.first, error)
        }
    }
    
    public func createFolder(_ name: String, onCompleted: @escaping (String?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = name
        file.mimeType = "application/vnd.google-apps.folder"
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
        query.fields = "id"
        
        service.executeQuery(query) { (ticket, folder, error) in
            onCompleted((folder as? GTLRDrive_File)?.identifier, error)
        }
    }
    
    public func createFolder(_ name: String, parents: String?, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = name
        if parents != nil {
            file.parents = [parents!]
            
        }
        file.mimeType = "application/vnd.google-apps.folder"
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
        query.fields = "id"
        
        service.executeQuery(query) { (ticket, folder, error) in
            onCompleted(folder as? GTLRDrive_File, error)
        }
    }
    
    public func delete(_ fileID: String, onCompleted: ((Error?) -> ())?) {
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: fileID)
        service.executeQuery(query) { (ticket, nilFile, error) in
            onCompleted?(error)
        }
    }
    
    public func getDirId(_ folderName: String, parentsId: String?, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        
        search(folderName,parents: parentsId) { (folderID, error) in
            
            if folderID != nil {
                onCompleted(folderID, nil)
            } else {
                self.createFolder(folderName, parents: parentsId, onCompleted: { (newFolderID, error) in
                    if error != nil {
                        print("Create failed_\(newFolderID), parentID \(parentsId): \(error)")
                    }
                    else {
                        
                        onCompleted(newFolderID, nil)
                    }
                })
            }
        }
    }
}

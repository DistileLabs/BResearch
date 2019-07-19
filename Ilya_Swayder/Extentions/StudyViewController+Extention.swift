//
//  StudyViewController+Extention.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 05/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension StudyViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // TODO
    }
    
    func openDocumentPicker(){
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
        let docMenu =  UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        docMenu.delegate = self
        docMenu.modalPresentationStyle = .formSheet
        self.present(docMenu, animated: true, completion: nil)
    }
    
}

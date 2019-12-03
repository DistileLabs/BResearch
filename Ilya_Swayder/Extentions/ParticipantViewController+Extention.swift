//
//  ParticipantViewController+Extention.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 01/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

extension ParticipantViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let newID = textField.text else { return true }
        
        let isUnique = addParticipant(ID: newID)
        
        if isUnique == true
        {
           textField.textColor = UIColor.black
            uniqueId = newID
            
            buttonEnable(button: singleLegStance)
            
            textField.resignFirstResponder()
            textField.isEnabled = false
            checkmarkImage.isHidden = false
            
        }
        else
        {
            badIdSelection(textField)
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func addParticipant(ID: String) -> Bool {
        
        return studyProperties.addParticipant(partcipantId: ID)
    }
    
    func badIdSelection(_ textField : UITextField)
    {
        textField.textColor = UIColor.red
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.warning)
    }
    
    func setIdToContinueStudy(uniqId:String) {
        participantID.textColor = UIColor.black
        participantID.text = uniqId
        uniqueId = uniqId

        participantID.isEnabled = false
        checkmarkImage.isHidden = false
        if studyProperties.isTrialFinishedForID(trialName: "Single Leg Stance", ID: uniqueId) == FINISHED {
            configureAvailableTrials()
        }
        else {
            buttonEnable(button: singleLegStance)
        }
    }
}


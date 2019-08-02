//
//  ListOfTrialsCell.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 02/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class ListOfTrialsHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func populateCell(label:String, numberOfTrials:String) {
        
        progressLabel.text = label;
        numberLabel.text = numberOfTrials
        
        if progressLabel.text == "Completed" {
            
            self.backgroundColor = UIColor(red: 46.0/255, green: 153.0/255, blue: 51.0/255, alpha: 1)
        }
        else
        {
            self.backgroundColor = UIColor(red: 221.0/255, green: 75.0/255, blue: 57.0/255, alpha: 1)
        }
    }
}

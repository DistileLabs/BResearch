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
            
            self.backgroundColor = UIColor(named: K.Colors.brandOrangeDark)
        }
        else
        {
            self.backgroundColor = UIColor(named: K.Colors.brandPinkDark)
        }
    }
}

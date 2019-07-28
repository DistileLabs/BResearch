//
//  ListOfTrialsContentCell.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 02/07/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import UIKit

class ListOfTrialsContentCell: UITableViewCell {
    
    @IBOutlet weak var timeAndDateLabel: UILabel!
    @IBOutlet weak var uniqueIdLabel: UILabel!
    @IBOutlet weak var trialsLabel: UILabel!
    @IBOutlet weak var optionPressLabel: UILabel!
    
    func populateCell(timeAndDate:String, ID:String, trialsLabels:String, shouldBePresseble:Bool) {
        
        timeAndDateLabel.text = timeAndDate
        uniqueIdLabel.text = ID
        trialsLabel.text = trialsLabels
        optionPressLabel.isHidden = shouldBePresseble == true ? true : false
        
        
    }
}

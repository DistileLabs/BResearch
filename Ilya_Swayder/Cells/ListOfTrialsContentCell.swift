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
    @IBOutlet weak var isSyncedView: UIView!
    
    func populateCell(timeAndDate:String, ID:String, trialsLabels:String, shouldBePresseble:Bool, isSynced:Bool) {
        
        timeAndDateLabel.text = timeAndDate
        uniqueIdLabel.text = ID
        trialsLabel.text = trialsLabels
        optionPressLabel.isHidden = shouldBePresseble != true ? true : false
        
        if isSynced == true {
            isSyncedView.backgroundColor = UIColor(named: K.Colors.brandYellowDark)
        }
        else if optionPressLabel.isHidden == false {
        
            isSyncedView.backgroundColor = UIColor.white
        }
        else {
            isSyncedView.backgroundColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1)
        }
    }
}

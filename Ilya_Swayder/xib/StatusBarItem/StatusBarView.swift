//
//  StatusBarView.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 17/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import UIKit

class StatusBarView: UIView {

    @IBOutlet weak var returnButtonOutlet: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var statusBarView: UIView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("StatusBarView", owner: self, options: nil)
        
        //self.statusBarView.backgroundColor = UIColor(red: 11.0/255, green: 84.0/255, blue: 185.0/255, alpha: 0.5)
        self.returnButtonOutlet.isHidden = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
        self.addSubview(self.statusBarView)
    }

}

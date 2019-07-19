//
//  StudyPtotocol.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 18/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

protocol PerformTrial {
    
    var name:String {get}
    var isFinished:Bool {get}
    
    func run()
    func getData()
    
}

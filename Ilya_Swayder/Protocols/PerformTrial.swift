//
//  StudyPtotocol.swift
//  Swayder_Meuhedet
//
//  Created by ilya_admin on 18/06/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation

let FINISHED = 1
let NOT_FINISHED = -1
let IN_PROGRESS = 0

protocol PerformTrial {
    
    var name:String {get}
    var isFinished:Int {get}
    
    func run()
    func getData()
    
}

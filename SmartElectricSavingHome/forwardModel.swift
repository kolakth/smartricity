//
//  forwardModel.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 4/13/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import Foundation

class forwardModel{
    var unit: String?
    var date: String?
    var avg: Any?
    var totalUnit: Any?
    
    init(unit: String?, date: String?, avg: Any?, totalUnit: Any?) {
        self.unit = unit
        self.date = date
        self.avg = avg
        self.totalUnit = totalUnit
    }
}

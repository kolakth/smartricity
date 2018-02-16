//
//  energyModel.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 2/12/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import Foundation

class energyModel{
    var voltage: String?
    var current: String?
    var power: String?
    var time: String?
    
    init(voltage: String?, current: String?, power: String?, time: String? ) {
        self.voltage = voltage
        self.current = current
        self.power = power
        self.time = time
    }
}

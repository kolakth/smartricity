//
//  graphModel.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 3/25/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import Foundation

class graphModel{
    var voltage: [Float]?
    var current: [Float]?
    var power: [Float]?
    var time: [Float]?
    
    init(voltage: [Float]?, current: [Float]?, power: [Float]?, time: [Float]? ) {
        self.voltage = voltage
        self.current = current
        self.power = power
        self.time = time
    }
}

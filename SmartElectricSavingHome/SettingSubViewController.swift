//
//  SettingSub.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 4/24/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Foundation

class SettingSubViewController: UIViewController {

    /*
@IBAction func BackSetting(_ sender: Any) {
self.performSegue(withIdentifier: "backSetting", sender: nil)
}*/

override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

@IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 5
    }

}

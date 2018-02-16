//
//  DashViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase

class DashViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mqttDelegateTesting(){
        //int data = FIRDatabase.database().
        
    }
    
}



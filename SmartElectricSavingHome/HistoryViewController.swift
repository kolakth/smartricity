//
//  DashViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController{
    
    var ref: DatabaseReference!

    static let shared = HistoryViewController()
    
    var voltage = 0
    var current = 0
    var power = 0
    var time = 0
    
    func toDictionary() -> [String : Any] {
        return[
            "voltage" : voltage,
            "current" : current,
            "power" : power,
            "time" : time]
    }
    
    let EnergyUsageRef = Database.database().reference().child("001")
    var EnergyUsage = [HistoryViewController]()
    
    @IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 3
        //tableView.delegate = self
        //tableView.dataSource = self
        
        
        //let userID = Auth.auth().currentUser?.uid
        
        HistoryViewController.shared.EnergyUsageRef.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
        })
        
       /* EnergyUsageRef.observe(.value, with: { (snapshot) in
            self.EnergyUsage.removeAll()
            print(snapshot)
        })*/
        
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




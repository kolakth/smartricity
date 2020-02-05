//
//  TableViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 2/11/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TableViewController: UITableViewController{
    
    
    var energyList = [energyModel]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return energyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> (UITableViewCell){
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewControllerTableViewCell

        let energy: energyModel
        
        energy = energyList[indexPath.row]
        
        cell.voltageLabel.text = energy.voltage
        cell.currentLabel.text = energy.current
        cell.powerLabel.text = energy.power
        cell.timeLabel.text = energy.time
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        let databaseRef = Database.database().reference().child("001/value")
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.energyList.removeAll()
                
                for energy in snapshot.children.allObjects as! [DataSnapshot]{
                    let energyObject = energy.value as? [String: AnyObject]
                    let energyVoltage = energyObject?["voltage"]
                    let energyCurrent = energyObject?["current"]
                    let energyPower = energyObject?["power"]
                    let energyTime = energyObject?["time"]
                    let energyEnergy = energyObject?["energy"]
                    
                    let energy = energyModel(voltage: energyVoltage as! String?, current: energyCurrent as! String?, power: energyPower as! String?, time: energyTime as! String?, energy: energyEnergy as! String?)
                    
                    SVProgressHUD.dismiss()
                    self.energyList.append(energy)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//
//  infoViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 5/22/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class infoViewController: UIViewController{
    
    @IBOutlet weak var limitLabel: UILabel!
    
    @IBOutlet weak var cycleText: UITextField!
    @IBOutlet weak var cycleLabel: UILabel!
    var limit = Double()
    var amount = Double()
    
    var cycle = Int32()
    
    var limitList = [limitModel]()
    var cycleList = [cycleModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //unit.keyboardType = UIKeyboardType.numberPad
        
        let databaseRefMax = Database.database().reference().child("001/limit")
        let databaseRef = Database.database().reference().child("001/cycle")
        
        databaseRefMax.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.limitList.removeAll()
                //self.maxLabel.text?.removeAll()
                
                for limit in snapshot.children.allObjects as! [DataSnapshot]{
                    let limitObject = limit.value as? [String: AnyObject]
                    let limitBudget = limitObject?["limit"]
                    
                    self.limit = Double(((limitBudget as! NSString).intValue))
                    let limitString = String(self.limit)
                    
                    self.limitLabel.text = limitString
                    
                }
            }
            else{
                //self.performSegue(withIdentifier: "popLimit", sender: nil)
            }
        })
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.cycleList.removeAll()
                //self.maxLabel.text?.removeAll()
                
                for cycle in snapshot.children.allObjects as! [DataSnapshot]{
                    let cycleObject = cycle.value as? [String: AnyObject]
                    let cycleDate = cycleObject?["day"]
                    
                    self.cycle = ((cycleDate as! NSString).intValue)
                    print("Self.cycle\(self.cycle)")
                    let cycleString = String(self.cycle)
                    print("CycleString: \(cycleString)")
                    self.cycleLabel.text = cycleString
                    
                }
            }
            else{
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return(true)
    }
    
}

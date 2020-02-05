//
//  ControlViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase

class ControlViewController: UIViewController {
    
    var ref : DatabaseReference!
    
    /*@IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.usr_name.text!, password: self.pass.text!) { (user, error) in
            self.ref = Database.database().reference(withPath: "Member")
            let memberData = member(email: self.usr_name.text!)
            let memberRef = self.ref.child(self.usr_name.text!)
            memberRef.setValue(memberData.toAnyObject())
        }
    }*/
    
    @IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.usr_name.delegate = self
        //self.pass.delegate = self
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




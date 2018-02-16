//
//  ForgetViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ForgetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    var ref : DatabaseReference!
    
    @IBAction func forgot(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = email.text,
            email != ""
            else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController: self, title: "Sorry!", message: "Please fill out email field")
                return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email, completion:{ (error) in
            guard error == nil else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController: self, title: "Sorry", message: error!.localizedDescription)
                return
            }
            SVProgressHUD.dismiss()
            AlertController.showAlert(_inViewController: self, title: "Reset password email was sent", message: "It's may take several minutes to received email")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10000)) {
            self.performSegue(withIdentifier: "goToLogin", sender: self.self)
            }
        })
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



//
//  SignUpViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    var ref : DatabaseReference!
    
    @IBAction func signup(_ sender: Any) {
        guard let username = UserName.text,
        username != "",
        let email = email.text,
        email != "",
        let pass = pass.text,
        pass != ""
            else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController: self, title: "Sorry!", message: "Please fill out all field")
                return
        }
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: pass, completion:{ (user, error) in
            guard error == nil else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController: self, title: "Sorry!", message: error!.localizedDescription)
                return
            }
            guard let user = user else{return}
            
                print(user.email ?? "Missing Email")
                print(user.uid)
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: {(error) in
                guard error == nil else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController:self, title: "Error", message: error!.localizedDescription)
                return
                }
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToHome", sender: nil)
                
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.email.delegate = self
        self.UserName.delegate = self
        self.pass.delegate = self
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



//
//  LoginViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    var authListener: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    
    @IBAction func SignIn(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = UserName.text,
        email != "",
        let password = pass.text,
        password != ""
            else {
            SVProgressHUD.dismiss()
            AlertController.showAlert(_inViewController: self, title: "Sorry!", message: "Please fill out all required fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            guard error == nil else{
                SVProgressHUD.dismiss()
                AlertController.showAlert(_inViewController: self, title: "Sorry!", message: error!.localizedDescription)
                return
            }
            guard let user = user else{return}
            print(user.email ?? "Missing Email")
            print(user.displayName ?? "Missing Display Name")
            print(user.uid)
            
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToHome", sender: nil)
        })
        
    }
    
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




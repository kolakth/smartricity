//
//  SettingViewController.swift
//  SmartElectricSavingHome
//
//  Created by Senior Room on 1/26/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func signOut(_ sender: UIButton) {
        SVProgressHUD.show()
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
        }catch{
            SVProgressHUD.dismiss()
            print(error)
        }
        
    }
    
    @IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let username =  Auth.auth().currentUser?.displayName,
        let email = Auth.auth().currentUser?.email
        else{
            return
            
        }
        //let usr_upper = username.uppercased()
        
        label.text = "\(username)!"
        emailLabel.text = email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

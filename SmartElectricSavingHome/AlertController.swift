//
//  AlertController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 2/10/18.
//  Copyright © 2018 SESH. All rights reserved.
//

//import Foundation
import UIKit

class AlertController{
    static func showAlert(_inViewController: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        _inViewController.present(alert, animated: true, completion: nil)
    }
    
    static func showSecondAlert(_inViewController: UIViewController, title: String, message: String){
        let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action2 = UIAlertController(title: "See the following instructions", message: "Dismiss to close this warning ", preferredStyle: .alert)
    }
    
}

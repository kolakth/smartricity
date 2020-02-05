//
//  popUpViewController.swift
//  SmartElectricSavingHome
//
//  Created by Senior Room on 1/26/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class popUpViewController: UIViewController {
    @IBOutlet var unit: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var budget: UITextField!
    @IBOutlet weak var factor: UITextField!
    @IBOutlet weak var billingCycle: UITextField!
    
    var forwardList = [forwardModel]()
    
    let databaseRef = Database.database().reference().child("/001/")
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    /*
    @IBAction func datePicker(_ sender: Any) {
        //let myTimeStamp = datePicker.date.timeIntervalSince1970
        let date = datePicker.date
        print(date)
        //print(myTimeStamp)
    }
    */

    @IBAction func billingCycleBtn(_ sender: Any) {
        SVProgressHUD.show()
        guard let bill = billingCycle.text, bill != ""
            else{
                SVProgressHUD.dismiss()
                
                AlertController.showAlert(_inViewController: self, title: "Sorrt", message: "Please fill your limit bill")
                return
        }
        
        self.databaseRef.child("cycle").childByAutoId().setValue(["day": bill])
        
        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func limitBtn(_ sender: Any) {
        
        SVProgressHUD.show()
        guard let budget = budget.text, budget != ""
            else{
                SVProgressHUD.dismiss()
                
                AlertController.showAlert(_inViewController: self, title: "Sorrt", message: "Please fill your limit bill")
                return
        }
        
        self.databaseRef.child("limit").childByAutoId().setValue(["limit": budget])
        
        self.performSegue(withIdentifier: "popUsage", sender: nil)
        
        SVProgressHUD.dismiss()
    }
    
    @IBAction func addbtn(_ sender: UIDatePicker){
        SVProgressHUD.show()
       guard let unit = unit.text, unit != "",
        let factor = factor.text, factor != ""
        else{
           SVProgressHUD.dismiss()
            AlertController.showAlert(_inViewController: self, title: "Sorry", message: "Please fill all field")
            return
        }
        let date = datePicker.date
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate:String = dateFormatter.string(from: date)
        print("Selected value \(selectedDate)")
        let x : Float = 0
        let num = Float(x)
        
        let unitDouble = Double(unit)
        let factorDouble = Double(factor)
        
        let total: Double = unitDouble! * factorDouble!
        let totalString = Double(total)
        
        self.databaseRef.child("forward").childByAutoId().setValue(["unit": unit, "date": selectedDate, "factor": factor ,"avg":num, "totalUnit": totalString
            ])
        SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: "back", sender: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //unit.keyboardType = UIKeyboardType.numberPad
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

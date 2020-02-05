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

class ForwardViewController: UIViewController {
    
    @IBOutlet weak var inputText: UITextField!
    
    @IBAction func push(_ sender: Any) {
        forward()
    }
    
    func forward(){
        let totalDay = 30
        var count = 1
        var hcount = 0
        var sum: Double = 0
        var avg: Double = 0
        var sumCC: Double = 0
        var currentCost: Double = 0
        
        var unitList = [Double]()
        var predictList = [Double]()
        
        for i in 0...30{
            guard let currentUnit = inputText.text,
            currentUnit != ""
            else{
                AlertController.showAlert(_inViewController: self, title: "Sorry!", message: "Please fill out all field")
                return
            }
            let currInt = Double(currentUnit)
            unitList.append(currInt!)
            
            print(unitList)
            
            sum = sum + unitList[i]
            //var countD: Double = count
            avg = sum/Double(count)
            
            let nHoliday = totalDay - (22 + hcount)
            let nWorkday = totalDay - (nHoliday + count)
            
            print("\nWork day left is: ", nWorkday)
            print("\nCurrent count", count)
            
            if(count % 7 == 0){
                currentCost = unitList[i] * 1.5
                hcount = hcount+1
                print("\nhcount", hcount)
            }else if(count % 7 != 0){
                currentCost = unitList[i] * 1
            }
            sumCC = sumCC + currentCost;
            
            print("\nCurrent Cost:", currentCost);
            
            let holidayCost = avg * 1.5 * Double(nHoliday)
            let workdayCost = avg * Double(nWorkday)
            
            let predict = holidayCost + workdayCost + sumCC
            predictList.append(Double(predict))
            
            print("\nCost at the end month: ", predictList)
            count = count + 1
            
            print ("\ncount: ",count)
            print ("sum: ", sum)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    
}


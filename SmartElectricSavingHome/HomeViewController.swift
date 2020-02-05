//
//  HomeViewController.swift
//  SmartElectricSavingHome
//
//  Created by Senior Room on 1/26/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore
import SwiftChart

class HomeViewController: UIViewController, ChartDelegate  {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            chartLabel.text = numberFormatter.string(from: NSNumber(value: value))
        }
    }
    
    
    @IBOutlet weak var wattLabel: UILabel!
    @IBOutlet weak var dailyUse: UILabel!
    @IBOutlet weak var monthlyUse: UILabel!
    @IBOutlet weak var labelW: UIView!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    
    
    var energyList = [energyModel]()
    var unit = Double()
    var force = [Double]()
    var time = [Float]()

    
    @IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        
        
        labelW._label(radius: 15, color:.white)
        
        dailyUse.text = "--"
        billLabel.text = "--"
        
        guard let username =  Auth.auth().currentUser?.displayName else{return}
        //let usr_upper = username.uppercased()
        
        label.text = "\(username)!"
        // Do any additional setup after loading the view.
        
        
        let databaseRef = Database.database().reference().child("001/value").queryLimited(toLast: 61) //25 //30 //60
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0{
                self.energyList.removeAll()
                self.force.removeAll()
                self.time.removeAll()
                
                for energy in snapshot.children.allObjects as! [DataSnapshot]{
                    let energyObject = energy.value as? [String: AnyObject]
                    let energyVoltage = energyObject?["voltage"]
                    let energyCurrent = energyObject?["current"]
                    let energyPower = energyObject?["power"]
                    let energyTime = energyObject?["time"]
                    let energyEnergy = energyObject?["energy"]
                    
                    let energy = energyModel(voltage: energyVoltage as! String?, current: energyCurrent as! String?, power: energyPower as! String?, time: energyTime as! String?, energy: energyEnergy as! String?)
                    
                    self.force.append((energyPower as! NSString).doubleValue)
                    
                    self.time.append((energyTime as! NSString).floatValue)
                    
                    let energyLabel = energyEnergy as! String?
                    //let current = energyCurrent as! String?
                    let power = energyPower as! String?
                    /*
                     let myFloat = (power as! NSString).floatValue
                     let dataFloat: [Float?] = myFloat as! [Float?]
                     print(dataFloat)*/
                    print (snapshot.childrenCount)
                    
                    //format: "%.2f",
                    var energyDouble = Float()
                    energyDouble = (energyLabel! as NSString).floatValue
                    energyDouble = energyDouble + 0.64 + 0.20
                    let energyP = String(format: "%.2f", energyDouble)
                    self.wattLabel.text = power
                    self.dailyUse.text = energyP
                    
                    self.unit = Double(((energyLabel! as NSString).intValue))
                    
                    var unitBill = self.unit + 0.64
                    var todayPrice = 0
                    
                    if(unitBill >= 0)
                    {   if (unitBill <= 150)
                    {   if(unitBill <= 15){
                        todayPrice = Int((unitBill * 2.3488));
                    }
                    else if (unitBill <= 25) {
                        todayPrice = Int((15 * 2.3488) + (unitBill - 15))
                    }
                    else if (unitBill <= 35) {
                        todayPrice = Int(65.114 + (unitBill - 25) * 3.2405)
                    }
                    else if (unitBill <= 100) {
                        //var a: Double = 0.0
                        //a = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405)
                        todayPrice = Int(97.519 + (unitBill - 65) * 3.6237)
                        
                    }
                    else if (unitBill <= 150) {
                        //var b: Double = 0.0
                        //b = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405) + (65 * 3.6237)
                        todayPrice = Int(333.0595 + (unitBill-100) * 3.7171) }
                    }
                    else if(unitBill <= 400) {
                        todayPrice = Int(487.26 + (unitBill - 150) * 3.221) }
                    else if(unitBill >= 400) {
                        todayPrice = Int(1542.71 + (unitBill - 400) * 4.4217) }
                        
                    }
                    self.billLabel.text = "฿ " + String(todayPrice)
                    self.energyList.append(energy)
                    
                    self.displayChart(data: self.force, axis: self.time)
                }
            }
            
            print(self.force)
            print(self.time)
        })

        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        chartLabel.text = ""
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    func displayChart(data: [Double], axis: [Float]){
        chart.delegate = self
        //let data: [Float] = energy
        //let data2: [Float] = [15]
        
        let series = ChartSeries(data)
        series.area = true
        series.line = true
        series.color = .white
        //series.colors = (.red , .green, 0)
        chart.gridColor = .white
        chart.labelColor = .white
        //[60 ,52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 8, 4, 0]
        //[0,2,4,6,8,10,12,14,16,18,20,22]
        //[32, 28, 24, 20, 16, 12, 8, 4, 0]
        chart.xLabels = [0, 10, 20, 30, 40, 50, 60]
        
        //chart.xLabels = axis
        chart.xLabelsFormatter = { String(Int(round($1))) + "s" }
        chart.yLabelsFormatter = { String(Int($1)) +  "W" }
        //chart.reloadInputViews()
        chart.removeAllSeries()
        chart.add(series)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension UIView{
    func _label(radius: CGFloat, color:UIColor = UIColor.clear) -> UIView {
        let labelW:UIView = self
        labelW.layer.cornerRadius = CGFloat(radius)
        labelW.layer.borderWidth = 1.2
        labelW.layer.borderColor = color.cgColor
        labelW.clipsToBounds = true
        return labelW
    }
}




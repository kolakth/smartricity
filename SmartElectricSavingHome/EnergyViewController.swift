//
//  DashViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import Firebase
import SwiftChart
import FSCalendar

class EnergyViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var MinLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var billToday: UILabel!
    @IBOutlet weak var billMax: UILabel!
    @IBOutlet weak var billMin: UILabel!
    @IBOutlet weak var billAvg: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet weak var avgPreferLabel: UILabel!
    @IBOutlet weak var avg05Label: UILabel!
    @IBOutlet weak var Avg15Label: UILabel!
    @IBOutlet weak var avg20Label: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func infoBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "popInfo", sender: nil)
    }
    var refreshControl = UIRefreshControl()
    
    var forwardList = [forwardModel]()
    var limitList = [limitModel]()
    var cycleList = [cycleModel]()
    
    var limit = Double()
    var cycle = Double()
    var amount = Double()
    var grandTotalDouble = Double()
    
    var totalUnit = [Float]()
    var grandTotal: Float?
    
    var unit = [Float]()
    var unitDouble = Double()
    var dateStr = [String]()
    var datesWithEvent = [String]()
    var billCycleDate = [String]()
    
    var maxfn: Float?
    var minfn: Float?
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let formatter2: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = DateFormatter.Style.short
        formatter2.timeStyle = DateFormatter.Style.none
        formatter2.dateFormat = "yyyy-MM-dd"
        return formatter2
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    
    @IBAction func add_btn(_ sender: Any) {
            self.performSegue(withIdentifier: "pop", sender: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
        print("calendar did select date \(self.formatter.string(from: date))")
        print("did select date \(self.formatter2.string(from: date))")
        let datev = self.formatter.string(from: date)
        print (datev)
        
        let databaseRef = Database.database().reference().child("001/forward").queryOrdered(byChild: "date").queryEqual(toValue: datev)
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0{
                self.forwardList.removeAll()
                self.unit.removeAll()
                self.unitLabel.text?.removeAll()
                //self.maxLabel.text?.removeAll()
                //self.MinLabel.text?.removeAll()
                //self.avgLabel.text?.removeAll()
                
                for forward in snapshot.children.allObjects as! [DataSnapshot]{
                    let forwardObject = forward.value as? [String: AnyObject]
                    let forwardUnit = forwardObject?["unit"]
                    let forwardDate = forwardObject?["date"]
                    let forwardAvg = forwardObject?["avg"]
                    let forwardtotalUnit = forwardObject?["totalUnit"]
                    
                    let forward = forwardModel(unit: forwardUnit as! String?, date: forwardDate as! String?, avg: forwardAvg as? Any, totalUnit: forwardtotalUnit as? Any)
                    print(snapshot.childrenCount)
                    
                    
                    //print("PASSING MAX: \(forward.max!) MIN:\(forward.min!) AVG: \(forward.avg!)")
                    
                     let unit = forwardUnit as! String?
                     self.unitDouble = Double(((forwardUnit as! NSString).intValue))
                    
                    //let max = (forward.max! as! NSNumber).stringValue
                    //let min = (forward.min! as! NSNumber).stringValue
                   // let avg = (forward.avg! as! NSNumber).stringValue
                    
                    //print("PASSING MAX: \(String(describing: max)) MIN:\(String(describing: min)) AVG: \(String(describing: avg))")
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    formatter.roundingMode = .up
                    
                    let calendar = Calendar.current
                    let date = self.formatter.date(from: forward.date!)
                    
                    let interval = calendar.range(of: .day, in: .month, for: date!)
                    let numInt = interval?.count
                    let numDouble = Double((interval?.count)!)
                    
                    let day = calendar.component(.day, from: date!)
                    
                    
                    print("Interval ::")
                    print(numInt!)
                    
                    let dayRemain = Double(numInt! - day)
                    print("DayRemaing: \(dayRemain)")
                    
                    //let forwardStr = String(describing: formatter.string(from: forward.unit as! NSNumber)!)
                    
                    //let maxStr = String(describing: formatter.string(from: forward.max as! NSNumber)!)
                    //let minStr = String(describing: formatter.string(from: forward.min as! NSNumber)!)
                    let avgStr = String(describing: formatter.string(from: forward.avg as! NSNumber)!)
                    
                    self.unitLabel.text = unit
                    //self.maxLabel.text = maxStr
                    //self.MinLabel.text = minStr
                    self.avgLabel.text = avgStr
                    //self.avgLabel.text = String(format: "%.2f", avg)
                    
                    let maxStr = String(format: "%.2f", self.maxfn!) //.stringValue
                    let minStr = String(format: "%.2f", self.minfn!) //?.stringValue
                    
                    //var maxStr = self.maxfn as! String?
                    //var minStr = self.minfn as! String?
                    
                    self.maxLabel.text = maxStr
                    self.MinLabel.text = minStr
                    
                    let unitBill = self.unitDouble
                    print(unitBill)
                    
                    let maxBill = self.grandTotalDouble + (Double(self.maxfn!) * dayRemain)
                    let minBill = self.grandTotalDouble + (Double(self.minfn!) * dayRemain)
                    let avgBill = self.grandTotalDouble + (Double(avgStr)! * dayRemain)
                    
                    print(maxBill)
                    print(minBill)
                    
                    var minPrice: Double = 0.0
                    var maxPrice: Double = 0.0
                    var avgPrice: Double = 0.0
                    var todayPrice: Double = 0.0
                    var Ft: Double = 0
                    var vat: Double = 0
                    var TotalPrice: Double = 0
                    
                    if(unitBill >= 0)
                    {   if (unitBill <= 150)
                    {   if(unitBill <= 15){
                        todayPrice = (unitBill * 2.3488)
                    }
                    else if (unitBill <= 25) {
                        todayPrice = (15 * 2.3488) + (unitBill - 15)
                    }
                    else if (unitBill <= 35) {
                        todayPrice = (15 * 2.3488) + (10 * 2.9882) + (unitBill - 25) * 3.2405
                    }
                    else if (unitBill <= 100) {
                        //var a: Double = 0.0
                        //a = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405)
                        todayPrice = 97.519 + (unitBill - 65) * 3.6237
                        
                    }
                    else if (unitBill <= 150) {
                        //var b: Double = 0.0
                        //b = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405) + (65 * 3.6237)
                        todayPrice = 333.0595 + (unitBill-100) * 3.7171 }
                    }
                    else if(unitBill <= 400) {
                        todayPrice = (150 * 3.2484) + (unitBill - 150) * 3.221 }
                    else if(unitBill >= 400) {
                        todayPrice = (150 * 3.2484) + (250 * 4.2218) + (unitBill - 400) * 4.4217 }
                        
                    }
                    
                    if(maxBill >= 0)
                    {   if (maxBill <= 150)
                        {   if(maxBill <= 15){
                            maxPrice = 38.22+(maxBill * 2.3488)
                        }
                            else if (maxBill <= 25) {
                            maxPrice = 38.22 + (15 * 2.3488) + (maxBill - 15)
                        }
                            else if (maxBill <= 35) {
                            maxPrice = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (maxBill - 25) * 3.2405
                        }
                            else if (maxBill <= 100) {
                            //var a: Double = 0.0
                            //a = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405)
                            maxPrice = 135.739 + (maxBill - 65) * 3.6237
                            
                        }
                        else if (maxBill <= 150) {
                            //var b: Double = 0.0
                            //b = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405) + (65 * 3.6237)
                            maxPrice = 371.28 + (maxBill-100) * 3.7171 }
                    }
                        else if(maxBill <= 400) {
                            maxPrice = 38.22 + (150 * 3.2484) + (maxBill - 150) * 3.221 }
                            else if(maxBill >= 400) {
                            maxPrice = 38.22 + (150 * 3.2484) + (250 * 4.2218) + (maxBill - 400) * 4.4217 }
                        
                    }
                    
                    if(minBill >= 0)
                    {   if (minBill <= 150)
                    {   if(minBill <= 15){
                        minPrice = 38.22+(minBill * 2.3488)
                    }
                    else if (minBill <= 25) {
                        minPrice = 38.22 + (15 * 2.3488) + (minBill - 15)
                    }
                    else if (minBill <= 35) {
                        minPrice = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (minBill - 25) * 3.2405
                    }
                    else if (minBill <= 100) {
                        //var a: Double = 0.0
                        //a = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405)
                        minPrice = 135.739 + (minBill - 65) * 3.6237
                        
                    }
                    else if (minBill <= 150) {
                        //var b: Double = 0.0
                        //b = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405) + (65 * 3.6237)
                        minPrice = 371.28 + (minBill-100) * 3.7171 }
                        
                    }
                    else if(minBill <= 400) {
                        minPrice = 38.22 + (150 * 3.2484) + (minBill - 150) * 3.221 }
                    else if(minBill >= 400) {
                        minPrice = 38.22 + (150 * 3.2484) + (250 * 4.2218) + (minBill - 400) * 4.4217 }
                        
                    }
                    
                    if(avgBill >= 0)
                    {   if (avgBill <= 150)
                    {   if(avgBill <= 15){
                        avgPrice = 38.22+(avgBill * 2.3488)
                    }
                    else if (avgBill <= 25) {
                        avgPrice = 38.22 + (15 * 2.3488) + (avgBill - 15)
                    }
                    else if (avgBill <= 35) {
                        avgPrice = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (avgBill - 25) * 3.2405
                    }
                    else if (avgBill <= 100) {
                        //var a: Double = 0.0
                        //a = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405)
                        avgPrice = 135.739 + (avgBill - 65) * 3.6237
                        
                    }
                    else if (avgBill <= 150) {
                        //var b: Double = 0.0
                        //b = 38.22 + (15 * 2.3488) + (10 * 2.9882) + (10 * 3.2405) + (65 * 3.6237)
                        avgPrice = 371.28 + (avgBill-100) * 3.7171 }
                        
                    }
                    else if(avgBill <= 400) {
                        avgPrice = 38.22 + (150 * 3.2484) + (avgBill - 150) * 3.221 }
                    else if(avgBill >= 400) {
                        avgPrice = 38.22 + (150 * 3.2484) + (250 * 4.2218) + (avgBill - 400) * 4.4217 }
                    }
                    
                    Ft = unitBill * (-0.332)
                    vat = (maxPrice+Ft) * 0.07
                    TotalPrice = maxPrice + Ft + vat
                    //print(Ft)
                    //print(vat)
                    //print(TotalPrice)
                    
                    self.billToday.text = "฿ " + String(describing: formatter.string(from: todayPrice as NSNumber)!)
                    self.billMax.text = "฿" + String(describing: formatter.string(from: maxPrice as NSNumber)!)
                    self.billMin.text = "฿" + String(describing: formatter.string(from: minPrice as NSNumber)!)
                    self.billAvg.text = "฿" + String(describing: formatter.string(from: avgPrice as NSNumber)!)
                    

                    self.forwardList.append(forward)
                }
            }else{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let todayDate = formatter.string(from: Date())
                print(todayDate)
                if(datev == todayDate){
                    
                    //***** Get Actual Usage ******
                    let databaseRef = Database.database().reference().child("001/value").queryLimited(toLast: 1)
                    
                    databaseRef.observe(DataEventType.value, with: { (snapshot) in
                        
                        if snapshot.childrenCount > 0{
                            for energy in snapshot.children.allObjects as! [DataSnapshot]{
                                let energyObject = energy.value as? [String: AnyObject]
                                let energyVoltage = energyObject?["voltage"]
                                let energyCurrent = energyObject?["current"]
                                let energyPower = energyObject?["power"]
                                let energyTime = energyObject?["time"]
                                let energyEnergy = energyObject?["energy"]
                                
                                let energy = energyModel(voltage: energyVoltage as! String?, current: energyCurrent as! String?, power: energyPower as! String?, time: energyTime as! String?, energy: energyEnergy as! String?)
                                
                                let energyLabel = energyEnergy as! String?
                                
                                var energyDouble = Float()
                                energyDouble = (energyLabel! as NSString).floatValue
                                let energyP = String(format: "%.2f", energyDouble)
                                
                                var unit = Double()
                                unit = Double(((energyLabel! as NSString).intValue))
                                
                                var unitBill = unit
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
                                
                                self.billToday.text = "฿ " + String(todayPrice)
                                
                                self.unitLabel.text = energyP
                                
                            }
                        }
                    })
                    
                    //***** END OF FN *****
                    
                }
                self.unitLabel.text = "--"
                //self.maxLabel.text = "--"
                //self.MinLabel.text = "--"
                //self.avgLabel.text = "--"
                self.billToday.text = "--"
                
            }
                })
        
        
        //print("date,", date)
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    //var datesWithEvent = ["2018-04-\()", "2018-04-09", "2018-04-15", "2018-04-20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateMaxMin((Any).self)
        self.cycleShow((Any).self)
        self.checkIfLimit{ () -> () in
            self.calculateRemain((Any).self)
            }
        
        //let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        //view.addSubview(calendar)
    }
    
    func checkIfLimit(handleComplete:@escaping (()->())) {
        let databaseRefMax = Database.database().reference().child("001/limit")
        
        //let databaseRefMin = Database.database().reference().child("001/forward/").queryOrdered(byChild: "unit").queryLimited(toFirst: 1)
        
        /* ----------------------BEGIN OF FIND MAX/MIN----------------------------*/
        databaseRefMax.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.limitList.removeAll()
                //self.maxLabel.text?.removeAll()
                
                for limit in snapshot.children.allObjects as! [DataSnapshot]{
                    let limitObject = limit.value as? [String: AnyObject]
                    let limitBudget = limitObject?["limit"]
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    formatter.roundingMode = .up
                    
                    self.limit = Double(((limitBudget as! NSString).intValue))
                    
                    //let limit = limitModel(limit: limitBudget as? Any)
                    print(snapshot.childrenCount)
                    
                    //let limitStr = limitBudget as! String?
                    
                    if(self.limit >= 0){
                        if (self.limit <= 558){
                            if(self.limit <= 74){ self.amount = (self.limit - 38.22) / 2.3488}
                            else if(self.limit <= 104){self.amount = ((self.limit - 73.452) / 2.9882) + 15 }
                            else if (self.limit <= 104) { self.amount = ((self.limit - 73.452) / 2.9882) + 15 }
                            else if (self.limit <= 136) { self.amount = ((self.limit - 103.432) / 3.2405) + 25 }
                            else if (self.limit <= 372) { self.amount = ((self.limit - 134.837) / 3.6237) + 35 }
                            else if (self.limit <= 558) { self.amount = ((self.limit - 371.3775) / 3.7171) + 100 }
                        }
                        else if (self.limit <= 1331) { self.amount = ((self.limit - 487.26) / 3.221) + 150 }
                        else if (self.limit >= 1331) { self.amount = ((self.limit - 1580.71) / 4.4217) + 400 }
                    }
                    
                    print("CheckLimit")
                    print(self.amount)
                    
                    let limStr = String(describing: formatter.string(from: self.amount as NSNumber )!)
                    
                    self.limitLabel.text = limStr
                    //self.limitList.append(limit)
                    handleComplete()
                }
            }
            else{
                self.performSegue(withIdentifier: "popLimit", sender: nil)
            }
        })
    }
    
    func calculateRemain(_ Sender: Any){
        let databaseRefMax = Database.database().reference().child("001/forward/")
        databaseRefMax.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0){
                self.forwardList.removeAll()
                for forward in snapshot.children.allObjects as! [DataSnapshot]{
                    let forwardObject = forward.value as? [String: AnyObject]
                    let forwardUnit = forwardObject?["unit"]
                    let forwardDate = forwardObject?["date"]
                    let forwardAvg = forwardObject?["avg"]
                    let forwardtotalUnit = forwardObject?["totalUnit"]
                    
                    let forward = forwardModel(unit: forwardUnit as? String, date: forwardDate as! String?, avg: forwardAvg as? Any, totalUnit: forwardtotalUnit as? Any)
                    print(snapshot.childrenCount)
                    
                   
                    self.totalUnit.append((forwardtotalUnit as! NSNumber).floatValue)
                    
                    
                    self.grandTotal = self.totalUnit.reduce(0, { x, y in
                       x + y
                    })
                    
                    self.grandTotalDouble = Double(self.grandTotal!)
                    
                    
                    print("OUT GRAND")
                    let result = self.amount - self.grandTotalDouble
                    
                    print("Amount: \(String(self.amount))")
                    print("GrandTotal: \(String(self.grandTotalDouble))")
                    print("Result: \(String(result))")
                    
                    let calendar = Calendar.current
                    let date = self.formatter.date(from: forward.date!)
                    
                    let interval = calendar.range(of: .day, in: .month, for: date!)
                    let numInt = interval?.count
                    
                    let day = calendar.component(.day, from: date!)
                    
                    
                    print("Interval ::")
                    print(numInt!)
                    
                    let dayRemain = numInt! - day
                    print("DayRemaing: \(dayRemain)")
                    let avg = result / Double(dayRemain)
                    
                    print("avg")
                    print(avg)
                    
                    let x05 = avg * 0.5
                    let x15 = avg * 1.5
                    
                    let x05Str = String(format: "%.2f", x05)
                    let x15Str = String(format: "%.2f", x15)
                    let avgStr = String(format: "%.2f", avg)
                    let remainStr = String(format: "%.2f", result)
                    print("RESULT")
                    print(result)
                    
                    self.remainLabel.text = remainStr
                    self.avg05Label.text = x05Str
                    self.Avg15Label.text = x15Str
                    self.avgPreferLabel.text = avgStr
                    //let remainStr = String(describing: formatter.string(from: result)!)
                    //print("IN GRAND")
                    //print(self.grandTotal)
                    //self.printResult((Any).self)
                    
 
                    self.forwardList.append(forward)
                }
            }
            else{
                //self.performSegue(withIdentifier: "popCycle", sender: nil)
            }
        })
    }
    
    //******************** CYCLE **************************************
    func cycleShow(_ Sender: Any) {
        let stringX = "12"
        let databaseRef = Database.database().reference().child("/001/cycle")
        
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.cycleList.removeAll()
                
                for cycle in snapshot.children.allObjects as! [DataSnapshot]{
                    let cycleObject = cycle.value as? [String: AnyObject]
                    let cycleDate = cycleObject?["day"]

                    //self.cycle = Double(((cycleDate as! NSString).intValue))
                    //let cycleStr = String(self.cycle)
                    
                    //print("Cycle: \(cycleStr)")

                }
            }
            else{
                self.performSegue(withIdentifier: "popCycle", sender: nil)
            }
        })
        
        
        
        print("IT's \(stringX)")
        
    }
    
    func calculateMaxMin(_ Sender: Any) {
        let databaseRefMax = Database.database().reference().child("001/forward/")
        
        //let databaseRefMin = Database.database().reference().child("001/forward/").queryOrdered(byChild: "unit").queryLimited(toFirst: 1)
        
        /* ----------------------BEGIN OF FIND MAX/MIN----------------------------*/
        databaseRefMax.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.forwardList.removeAll()
                self.datesWithEvent.removeAll()
                self.dateStr.removeAll()
                //self.maxLabel.text?.removeAll()
                
                for forward in snapshot.children.allObjects as! [DataSnapshot]{
                    let forwardObject = forward.value as? [String: AnyObject]
                    let forwardUnit = forwardObject?["unit"]
                    let forwardDate = forwardObject?["date"]
                    let forwardAvg = forwardObject?["avg"]
                    let forwardtotalUnit = forwardObject?["totalUnit"]
                    
                    let forward = forwardModel(unit: forwardUnit as? String, date: forwardDate as! String?, avg: forwardAvg as? Any, totalUnit: forwardtotalUnit as? Any)
                    print(snapshot.childrenCount)
                    
                    self.unit.append((forwardUnit as! NSString).floatValue)
                    //self.unitInt = forwardUnit as! Int
                    self.dateStr.append(forwardDate as! String)
                    
                    self.datesWithEvent = self.dateStr
                    
                    //print(self.datesWithEvent)
                    //print(self.unit)
                    
                    self.maxfn = (self.unit.max()! + Float(forward.avg as! NSNumber))/2
                    self.minfn = (self.unit.min()! + Float(forward.avg as! NSNumber))/2
                    /*
                    if(Int(Funit)!) == 0){
                        print("Excluded")
                    }else{
                    }*/
 
                    //print(self.maxfn)
                    //print(self.minfn)
                    
                    //let max = forwardUnit as! String?
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    formatter.roundingMode = .up
                    
                    //let maxStr = String(describing: formatter.string(from: forward.max as! NSNumber)!)
                    //self.maxLabel.text = max
                    
                    self.forwardList.append(forward)
                    
                }
            }
            else{
                //self.performSegue(withIdentifier: "popCycle", sender: nil)
            }
        })
        /*----------------------END OF FIND MAX/MIN----------------------------*/
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(self.datesWithEvent)
        let dateString = self.formatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }else {return 0
        }
    }
    
    let fillDefaultColors = ["2018-05-10": UIColor.purple, "2018-05-06": UIColor.green, "2018-05-20": UIColor.cyan, "2018-05-31": UIColor.yellow]
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, numberOfEventsFor date: Date) -> UIColor? {
        print(self.datesWithEvent)
        let dateString = self.formatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return UIColor.purple
        }else{
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return(true)
    }
    
    @IBAction func backFromModal(_ seque: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 2
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Float{
    var stringValue:String{
        return "\(self)"
    }
}





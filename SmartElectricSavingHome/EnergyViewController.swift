//
//  DashViewController.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 10/26/17.
//  Copyright © 2017 SESH. All rights reserved.
//

import UIKit
import SwiftChart


class EnergyViewController: UIViewController, ChartDelegate{
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    

    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var valueText: UITextField!
    // @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func addBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
        chart.delegate = self

        let data: [Float] = [0, -2, -2, 3, -3, 4, 1, 0, -1]
        
        let series = ChartSeries(data)
        series.area = true
        chart.xLabels = [0, 3, 6, 9, 12, 15, 18, 21, 24]
        chart.xLabelsFormatter = { String(Int(round($1))) + "h" }
        chart.add(series)
        
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

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
}





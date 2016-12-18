//
//  ViewController.swift
//  Gyro
//
//  Created by Joe Ferrucci on 12/17/16.
//  Copyright © 2016 Joe Ferrucci. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    // Current
    var xCurrent: Double = 0
    var yCurrent: Double = 0
    var zCurrent: Double = 0
    
    // Previous
    var xPrevious: Double = 0
    var yPrevious: Double = 0
    var zPrevious: Double = 0
    
    // Average
    var xAverage: Double = 0
    var yAverage: Double = 0
    var zAverage: Double = 0
    
    // Series
    var xSeries: [Double] = []
    var ySeries: [Double] = []
    var zSeries: [Double] = []
    
    // Orders of Magntitude Greater or Lesser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreMotion()
    }
    
    func setupCoreMotion() {
        manager.gyroUpdateInterval = 0.1
        
        let queue = OperationQueue.main
        manager.startGyroUpdates(to: queue) { (data, error) in
            guard error == nil else { print("CM Error = \(error)"); return }
            guard let data = data else { return }
            
            self.updateRotationValues(with: data)
            self.runTimeSeries()
        }
        
    }
    
    func updateRotationValues(with gyroData: CMGyroData) {
        // Save old values
        xPrevious = xCurrent
        yPrevious = yCurrent
        zPrevious = zCurrent
        
        // Update with new ones
        xCurrent = gyroData.rotationRate.x
        yCurrent = gyroData.rotationRate.y
        zCurrent = gyroData.rotationRate.z
        
        // Append new values
        xSeries.append(xCurrent)
        ySeries.append(yCurrent)
        zSeries.append(zCurrent)
    }
    
    func runTimeSeries() {
        xAverage = xSeries.reduce(0, +) / Double(xSeries.count)
        yAverage = ySeries.reduce(0, +) / Double(ySeries.count)
        zAverage = zSeries.reduce(0, +) / Double(zSeries.count)
        
        let resetInterval = 30
        if xSeries.count > resetInterval || ySeries.count > resetInterval || zSeries.count > resetInterval {
            xSeries = [xAverage]
            ySeries = [yAverage]
            zSeries = [zAverage]
            self.updateLabels(usingAverage: true)
            print("Reset series.")
        }
    }
    
    func updateLabels(usingAverage useAverage: Bool = false) {
        if useAverage {
            xLabel.text = "\(xAverage)"
            yLabel.text = "\(yAverage)"
            zLabel.text = "\(zAverage)"
        } else {
            xLabel.text = "\(xCurrent)"
            yLabel.text = "\(yCurrent)"
            zLabel.text = "\(zCurrent)"
        }
    }
}


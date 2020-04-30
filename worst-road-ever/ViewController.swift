//
//  ViewController.swift
//  Test
//
//  Created by Fabian Karl on 29.04.20.
//  Copyright © 2020 Fabian Karl. All rights reserved.
//

import UIKit
import CoreMotion
import simd


class ViewController: UIViewController {
    
    struct Queue<T> {
         var list = [T]()
    

    mutating func enqueue(_ element: T) {
          list.append(element)
    }
    mutating func dequeue() -> T? {
         if !list.isEmpty {
           return list.removeFirst()
         } else {
           return nil
         }
    }
    }
    
    @IBOutlet weak var surfaceImg: UIImageView!
    
    let motion: CMMotionManager = CMMotionManager()
    var timer: Timer = Timer()
    var vibration_value: Double = 0.0
    
    var vertiacl_accelerations = Queue<Double>()
    
    @IBOutlet weak var vibrationLable: UILabel!
    var vib_value: Double = 0.0
    let vibThreshold: Double = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vibrationLable.text = "0.00"
        // Do any additional setup after loading the view.
        
        motion.startDeviceMotionUpdates()
        startAccelerometers()
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                // Get the accelerometer data.
                // taken from https://stackoverflow.com/questions/47073389/detect-acceleration-in-absolute-vertical-axis
                if let deviceMotion = self.motion.deviceMotion {
                    
                    let gravityVector = simd_double3(x: deviceMotion.gravity.x,
                                                     y: deviceMotion.gravity.y,
                                                     z: deviceMotion.gravity.z)
                    
                    let userAccelerationVector = simd_double3(x: deviceMotion.userAcceleration.x,
                                                              y: deviceMotion.userAcceleration.y,
                                                              z: deviceMotion.userAcceleration.z)
                    
                    // Acceleration to/from earth
                    let zVector = gravityVector * userAccelerationVector
                    let zAcceleration = simd_length(zVector)
                    let direction = sign(Double(zVector.x * zVector.y * zVector.z))
                    print(zAcceleration*direction)
                    let values = self.vertiacl_accelerations.list
                    if (values.count >= 120) {
                        let vib_value = values.max()! - values.min()!
                        self.vibrationLable.text = String(format:"%.2f", vib_value)
                        self.updateSurfaceImg(vibration: vib_value)
                        self.vertiacl_accelerations.dequeue()
                        
                    }
                    self.vertiacl_accelerations.enqueue(zAcceleration*direction)
                }
                
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }

    func updateSurfaceImg(vibration: Double) {
        if (vibration < vibThreshold) {
            surfaceImg.image = #imageLiteral(resourceName: "1599px-Spring_in_Bystroistokskiy_district_of_Altai_Krai_Russia_06")
        } else {
            surfaceImg.image = #imageLiteral(resourceName: "1600px-Mountain-track1")
        }
    }
    
}


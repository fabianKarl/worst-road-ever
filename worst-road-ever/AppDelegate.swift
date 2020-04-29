//
//  AppDelegate.swift
//  worst-road-ever
//
//  Created by Fabian Karl on 29.04.20.
//  Copyright © 2020 Fabian Karl. All rights reserved.
//

import UIKit
import CoreMotion
import simd




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
    
    let motion: CMMotionManager = CMMotionManager()
    var timer: Timer = Timer()
    var vibration_value: Double = 0
    
    var vertiacl_accelerations = Queue<Double>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        motion.startDeviceMotionUpdates()
        startAccelerometers()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
                        self.vibration_value = values.max()! - values.min()!
                        self.vertiacl_accelerations.dequeue()
                    }
                    self.vertiacl_accelerations.enqueue(zAcceleration*direction)
                }
                
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    
}


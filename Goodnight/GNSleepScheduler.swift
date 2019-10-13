//
//  SleepManager.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

class GNSleepScheduler {
    
    // MARK: - Properties
    
    private var timer: Timer?
    var sleepTimer: GNSleepTimer?
    
    // MARK: - Initializers
    
    init() {
        self.timer = nil
        self.sleepTimer = nil
    }
    
    // MARK: - Public Methods
    
    func scheduleSleep()
    
//    func sleep() {
//        let interface = PMSetInterface()
//        interface.sleepNow()
//    }
//
//    func scheduleSleep(at date: Date) {
//        if let existingTimer = self.sleepTimer {
//            existingTimer.invalidate()
//            self.sleepTimer = nil
//        }
//
//        let newTimer = Timer(fire: date, interval: 0, repeats: false) { (timer) in
//            self.sleep()
//        }
//        RunLoop.current.add(newTimer, forMode: .common)
//
//        self.sleepTimer = newTimer
//    }
//
//    func cancelScheduledSleep() {
//        self.sleepTimer?.invalidate()
//        self.sleepTimer = nil
//    }
    
}

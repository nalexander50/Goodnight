//
//  GNSleepScheduler.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/26/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Combine

class GNSleepScheduler {
    
    // MARK: Properties
    
    private var internalTimer: Timer?
    private var sleepTimer: GNSleepTimer?
    private var sleepTimerSubscription: AnyCancellable?
    
    init(sleepTimerStream: GNSleepTimerStream) {
        self.sleepTimerSubscription = sleepTimerStream.sink(receiveValue: self.onNewSleepTimer)
    }
    
    deinit {
        self.sleepTimerSubscription?.cancel()
    }
    
    // MARK: Public Methods
    
    func scheduleSleep(after sleepTimer: GNSleepTimer) {
        if let timer = self.createTimer(forSleepTimer: sleepTimer) {
            self.sleepTimer = sleepTimer
            self.internalTimer = timer
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    func cancelScheduledSleep() {
        self.internalTimer?.invalidate()
        self.internalTimer = nil
        self.sleepTimer = nil
    }
    
    // MARK: Private Methods
    
    private func onNewSleepTimer(sleepTimer: GNSleepTimer?) {
        if let sleepTimer = sleepTimer {
            self.scheduleSleep(after: sleepTimer)
        } else {
            self.cancelScheduledSleep()
        }
    }
    
    private func createTimer(forSleepTimer sleepTimer: GNSleepTimer) -> Timer? {
        switch sleepTimer {
        
        case .afterMinutes(let minutes):
            if let fireDate = Calendar.current.date(byAdding: DateComponents(minute: minutes), to: Date()) {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    print("Sleep")
                }
            }
        case .afterHours(let hours):
            if let fireDate = Calendar.current.date(byAdding: DateComponents(hour: hours), to: Date()) {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    print("Sleep")
                }
            }
        case .until(let date):
            return Timer(fire: date, interval: 0, repeats: false) { (timer) in
                print("Sleep")
            }
        case .whileBatteryAbove(let abovePercentage):
            return Timer(timeInterval: 15, repeats: true) { (timer) in
                let interface = GNPMSetInterface()
                if let currentPercentage = interface.getBatteryStatus()?.batteryPercentage {
                    if currentPercentage <= abovePercentage {
                        print("Sleep")
                    }
                }
            }
        case .whileAppIsRunning(_):
            return Timer()
            
        #if DEBUG
        case .debugAfterSeconds(let seconds):
            if let fireDate = Calendar.current.date(byAdding: DateComponents(second: seconds), to: Date()) {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    print("Sleep")
                }
            }
        #endif
            
        }
        
        return nil
    }
    
}

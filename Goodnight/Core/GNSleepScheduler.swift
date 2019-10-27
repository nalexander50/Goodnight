//
//  GNSleepScheduler.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/26/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa // todo
import SwiftUI // todo
import Combine

class GNSleepScheduler {
    
    // MARK: Properties
    
    private var fireDate: Date?
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
            
            // todo
            if let fireDate = self.fireDate {
                let popover = NSPopover()
                popover.contentViewController = NSHostingController(rootView: GNCountdownView(viewModel: GNCountdownViewModel(toDate: fireDate)))
                GNStreams.statusItemPopoverTwoWayStream.send(popover)
            }
        } else {
            self.cancelScheduledSleep()
            GNStreams.statusItemPopoverTwoWayStream.send(nil) // todo
        }
    }
    
    private func sleep() {
        self.cancelScheduledSleep()
    }
    
    private func createTimer(forSleepTimer sleepTimer: GNSleepTimer) -> Timer? {
        
        switch sleepTimer {
        
        case .afterMinutes(let minutes):
            self.fireDate = Calendar.current.date(byAdding: DateComponents(minute: minutes), to: Date())
            if let fireDate = self.fireDate {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    self.sleep()
                }
            }
            
        case .afterHours(let hours):
            self.fireDate = Calendar.current.date(byAdding: DateComponents(hour: hours), to: Date())
            if let fireDate = self.fireDate {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    self.sleep()
                }
            }
            
        case .until(let date):
            self.fireDate = date
            if let fireDate = self.fireDate {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    self.sleep()
                }
            }
            
        case .whileBatteryAbove(let abovePercentage):
            return Timer(timeInterval: 15, repeats: true) { (timer) in
                let interface = GNPMSetInterface()
                if let currentPercentage = interface.getBatteryStatus()?.batteryPercentage {
                    if currentPercentage <= abovePercentage {
                        self.sleep()
                    }
                }
            }
            
        case .whileAppIsRunning(let application):
            return Timer(timeInterval: 15, repeats: true) { (timer) in
                if application.isTerminated {
                    self.sleep()
                }
            }
            
        #if DEBUG
        case .debugAfterSeconds(let seconds):
            self.fireDate = Calendar.current.date(byAdding: DateComponents(second: seconds), to: Date())
            if let fireDate = self.fireDate {
                return Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                    self.sleep()
                }
            }
        #endif
            
        }
        
        return nil
    }
    
}

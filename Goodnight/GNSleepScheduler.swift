////
////  SleepManager.swift
////  Goodnight
////
////  Created by Nick Alexander on 10/7/19.
////  Copyright © 2019 Nick Alexander. All rights reserved.
////
//
//import Foundation
//
///// Responsible for scheduling future sleep events based on specified conditions
//class GNSleepScheduler {
//    
//    // MARK: - Singleton
//    
//    /// The current sleep scheduler.
//    static let current: GNSleepScheduler = GNSleepScheduler()
//    
//    // MARK: - Properties
//    
//    private var internalTimer: Timer?
//    private var sleepTimer: GNSleepTimer?
//    
//    /**
//     Returns `true` if there is a scheduled sleep event
//     */
//    var isSleepScheduled: Bool {
//        get {
//            return self.internalTimer != nil
//        }
//    }
//    
//    /// Returns a `string` indicating when the current device will sleep according to the active sleep timer.
//    var getScheduledSleepStatus: String? {
//        get {
//            guard let internalTimer = self.internalTimer else {
//                return nil
//            }
//            
//            guard let sleepTimer = self.sleepTimer else {
//                return nil
//            }
//            
//            switch sleepTimer {
//            
//            case .afterMinutes(_):
//                return self.formatTimeInterval(abs(Date().timeIntervalSince(internalTimer.fireDate)))
//            case .afterHours(_):
//                return self.formatTimeInterval(abs(Date().timeIntervalSince(internalTimer.fireDate)))
//            case .until(_):
//                return self.formatTimeInterval(abs(Date().timeIntervalSince(internalTimer.fireDate)))
//            case .whileBatteryAbove(let percentage):
//                return "Until battery level drops to \(percentage)%."
//            case .whileAppIsRunning(let app):
//                return "While \(app.localizedName ?? "Unknown Process") is running."
//            }
//        }
//    }
//    
//    // MARK: - Initializers
//    
//    /// Creates a new sleep scheduler with no scheduled events. For internal use only.
//    private init() {
//        self.internalTimer = nil
//        self.sleepTimer = nil
//    }
//    
//    // MARK: - Public Methods
//    
//    /**
//     Schedules the device to go to sleep after the specified sleep timer conditions are met. Before the device sleeps, the scheduler is returned to a default state.
//     
//     - Parameter sleepTimer: The sleep timer specifying under what conditions the device should go to sleep.
//     - Remark: Note: the device will enter sleep mode after the sleep timer resolves, and the scheduler will be returned to a default state.
//     */
//    func scheduleSleep(afterTimer sleepTimer: GNSleepTimer) {
//        self.sleepTimer = sleepTimer
//        self.internalTimer = self.createTimer(forSleepTimer: sleepTimer)
//        RunLoop.current.add(self.internalTimer!, forMode: .common)
//    }
//    
//    /**
//     Cancels the currently scheduled sleep and returns the scheduler to a default state.
//     */
//    func cancelScheduledSleep() {
//        self.internalTimer?.invalidate()
//        self.internalTimer = nil
//        self.sleepTimer = nil
//    }
//    
//    // MARK: - Create Timer Methods
//    
//    /**
//     Creates a timer that fires when the conditions specified by the sleep timer are met. When the timer fires, the device sleeps and the scheduler is returned to a default state. if the sleep timer specifies invalid conditions, returns `nil`.
//     
//     - Parameter sleepTimer: The sleep timer specifying under what conditions the device should go to sleep.
//     - Returns: A timer that fires when the sleep timer conditions are met. If the sleep timer specifies invalid conditions, returns `nil`.
//     */
//    private func createTimer(forSleepTimer sleepTimer: GNSleepTimer) -> Timer? {
//        switch sleepTimer {
//        
//        case .afterMinutes(let minutes):
//            if let fireDate = Calendar.current.date(byAdding: DateComponents(minute: minutes), to: Date()) {
//                return Timer(fire: fireDate, interval: 0, repeats: false, block: { timer in
//                    self.cancelScheduledSleep()
//                    self.sleepNow()
//                })
//            }
//        case .afterHours(let hours):
//            if let fireDate = Calendar.current.date(byAdding: DateComponents(hour: hours), to: Date()) {
//                return Timer(fire: fireDate, interval: 0, repeats: false, block: { timer in
//                    self.cancelScheduledSleep()
//                    self.sleepNow()
//                })
//            }
//        case .until(let date):
//            return Timer(fire: date, interval: 0, repeats: false) { timer in
//                self.cancelScheduledSleep()
//                self.sleepNow()
//            }
//            // TODO make polling intervale configurable?
//        case .whileBatteryAbove(let percentage):
//            return Timer(timeInterval: 60, repeats: true) { timer in
//                if let currentPercentage = self.getBatteryPercentage() {
//                    if currentPercentage < percentage {
//                        self.cancelScheduledSleep()
//                        self.sleepNow()
//                    }
//                }
//            }
//            // TODO make polling intervale configurable?
//        case .whileAppIsRunning(let application):
//            return Timer(timeInterval: 60, repeats: true) { timer in
//                if application.isTerminated {
//                    self.cancelScheduledSleep()
//                    self.sleepNow()
//                }
//            }
//        }
//        
//        return nil
//    }
//    
//    // MARK: - PMSet Interface Methods
//    
//    /**
//     Sends the device to sleep using the `pmset` utility.
//     */
//    private func sleepNow() {
//        let interface = PMSetInterface()
//        interface.sleepNow()
//    }
//    
//    /**
//     Retrieves the device's current battery percentage using the `pmset` utility. If the battery information cannot be determined, returns `nil`.
//     
//     - Returns: The device's current battery percentage otherwise `nil`.
//     */
//    private func getBatteryPercentage() -> Int? {
//        let interface = PMSetInterface()
//        return interface.getBatteryStatus()?.batteryPercentage
//    }
//    
//    // MARK: - Utility Methods
//    
//    /**
//     Formats a time interval into a human readable string.
//     
//     - Parameter timeInterval: The time interval to format.
//     - Returns: A human readable string representing the time interval.
//     */
//    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String? {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day, .hour, .minute, .second]
//        formatter.allowsFractionalUnits = false
//        formatter.maximumUnitCount = 4
//        formatter.unitsStyle = .full
//        return formatter.string(from: timeInterval)
//    }
//    
//}

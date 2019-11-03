//
//  GNTimerFactory.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import AppKit
import Foundation

class GNTimerFactory {

    // MARK: - Type Aliases

    typealias Result = (fireDate: Date?, timer: Timer)
    typealias TimerResolveAction = (Timer) -> ()

    // MARK: - Properties

    private let sleepConditions: GNSleepConditions
    private let action: TimerResolveAction

    // MARK: - Initializers

    init(withConditions sleepConditions: GNSleepConditions, action: @escaping TimerResolveAction) {
        self.sleepConditions = sleepConditions
        self.action = action
    }

    // MARK: - Public Methods

    func createTimer() -> Result {
        switch self.sleepConditions {
            case let .afterMinutesElapsed(minutes):
                return self.createTimer(byAddingComponentsToNow: DateComponents(minute: minutes))

            case let .afterHoursElapsed(hours):
                return self.createTimer(byAddingComponentsToNow: DateComponents(hour: hours))

            case let .afterDate(date):
                return self.createTimer(firingAt: date)

            case let .whenBatteryBelow(targetPercentage):
                return self.createTimerMonitoringBatteryLevel(targetPercentage: targetPercentage)

            case let .whenAppTerminates(application):
                return self.createTimerMonitoringApplication(application)

            #if DEBUG
                case let .afterSecondsElapsed(seconds):
                    return self.createTimer(byAddingComponentsToNow: DateComponents(second: seconds))
            #endif
        }
    }

    // MARK: - Private Mehtods

    private func createTimer(firingAt fireDate: Date) -> Result {
        let timer = Timer(fire: fireDate, interval: 0, repeats: false, block: action)
        return (fireDate, timer)
    }

    private func createTimer(byAddingComponentsToNow components: DateComponents) -> Result {
        if let fireDate = Calendar.current.date(byAdding: components, to: Date()) {
            return self.createTimer(firingAt: fireDate)
        } else {
            fatalError("Could not calculate date")
        }
    }

    private func createTimerMonitoringBatteryLevel(targetPercentage: Int) -> Result {
        // todo add interval to config
        let timer = Timer(timeInterval: 15, repeats: true) { timer in
            let interface = GNPMSetInterface()
            if let currentPercentage = interface.getBatteryStatus()?.batteryPercentage {
                if currentPercentage <= targetPercentage {
                    self.action(timer)
                }
            }
        }
        return (nil, timer)
    }

    private func createTimerMonitoringApplication(_ application: NSRunningApplication) -> Result {
        // todo add interval to config
        let timer = Timer(timeInterval: 15, repeats: true) { timer in
            if application.isTerminated {
                self.action(timer)
            }
        }
        return (nil, timer)
    }

}

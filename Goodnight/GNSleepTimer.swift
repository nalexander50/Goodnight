//
//  SleepTimer.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/10/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import AppKit

enum GNSleepTimer {
    case forMinutes(_ minutes: Int)
    case forHours(_ hours: Int)
    case until(_ date: Date)
    case until(batteryPercentage: Double)
    case until(batteryTimeRemaining: TimeInterval)
    case whileAppIsRunning(_ application: NSRunningApplication) // NSWorkspace.shared.runningApplications
}

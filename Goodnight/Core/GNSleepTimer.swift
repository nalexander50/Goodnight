//
//  GNSleepTimer.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa

/// Indicates under what conditions the device should sleep.
enum GNSleepTimer {
    
    case afterMinutes(_ minutes: Int)
    case afterHours(_ hours: Int)
    case until(_ date: Date)
    case whileBatteryAbove(percentage: Int)
    case whileAppIsRunning(application: NSRunningApplication) // NSWorkspace.shared.runningApplications
    
    #if DEBUG
    case debugAfterSeconds(_ seconds: Int)
    #endif
    
}

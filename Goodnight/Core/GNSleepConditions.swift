//
//  GNSleepConditions.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Foundation

/// Indicates under what conditions the device should sleep.
enum GNSleepConditions {
    case afterMinutesElapsed(_ minutes: Int)
    case afterHoursElapsed(_ hours: Int)
    case afterDate(_ date: Date)
    case whenBatteryBelow(percentage: Int)
    case whenAppTerminates(application: NSRunningApplication) // NSWorkspace.shared.runningApplications

    #if DEBUG
        case afterSecondsElapsed(_ seconds: Int)
    #endif
}

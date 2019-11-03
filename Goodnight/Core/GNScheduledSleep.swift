//
//  GNScheduledSleep.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

struct GNScheduledSleep {
    var fireDate: Date?
    var timer: Timer
    var conditions: GNSleepConditions
}

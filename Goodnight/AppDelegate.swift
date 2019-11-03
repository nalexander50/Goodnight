//
//  AppDelegate.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var sleepScheduler: GNSleepScheduler!
    private var statusItemService: GNStatusItemService!

    func applicationDidFinishLaunching(_: Notification) {
        self.sleepScheduler = GNSleepScheduler()
        self.statusItemService = GNStatusItemService()
    }

    func applicationWillResignActive(_: Notification) {
        self.statusItemService.resignActive()
    }
}

//
//  AppDelegate.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var sleepScheduler: GNSleepScheduler!
    private var statusItemService: GNStatusItemService!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.sleepScheduler = GNSleepScheduler(sleepTimerStream: GNStreams.sleepTimerStream)
        self.statusItemService = GNStatusItemService(popoverStream: GNStreams.statusItemPopoverStream, sleepTimerStream: GNStreams.sleepTimerTwoWayStream)
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        self.statusItemService.resignActive()
    }

}

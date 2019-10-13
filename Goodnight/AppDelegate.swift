//
//  AppDelegate.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    private var statusBarItem: NSStatusItem!
    private var popoverManager: GNMenuPopoverManager!
    
    // MARK: - NSApplicationDelegate

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem.button?.title = "💤"
        self.statusBarItem.button?.toolTip = "Sleeping Soon"
        
        self.popoverManager = GNMenuPopoverManager(anchoredTo: self.statusBarItem.button!, withContent: MenuBarPopoverView())
        self.statusBarItem.button?.action = #selector(self.popoverManager.toggle)
        
        let menuBuilder = GNMenuBuilder(popoverManager: self.popoverManager)
        self.statusBarItem.menu = menuBuilder.buildMenu()
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        self.popoverManager.close()
    }

}


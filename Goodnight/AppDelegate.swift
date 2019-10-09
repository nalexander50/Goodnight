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
    
    private var statusBarItem: NSStatusItem? = nil
    private var statusBarItemPopover: NSPopover? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem?.button?.title = "💤"
        
        self.statusBarItemPopover = NSPopover()
        self.statusBarItemPopover!.behavior = .transient
        self.statusBarItemPopover!.contentViewController = NSHostingController(rootView: MenuBarPopoverView())
        
        self.statusBarItem?.button?.action = #selector(self.toggleStatusBarItemPopover)
    }
    
    @objc private func toggleStatusBarItemPopover() {
        if let popover = self.statusBarItemPopover {
            if let button = self.statusBarItem?.button {
                if (popover.isShown) {
                    popover.performClose(self)
                } else {
                    popover.show(relativeTo: .zero, of: button, preferredEdge: .minY)
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        self.statusBarItemPopover?.performClose(self)
    }

}


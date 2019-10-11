//
//  MenuBuilder.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/10/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa

class GNMenuBuilder {
    
    // MARK: - Properties
    
    private let popoverManager: GNMenuPopoverManager
    
    // MARK: - Initializers
    
    init(popoverManager: GNMenuPopoverManager) {
        self.popoverManager = popoverManager
    }
    
    // MARK: - Public Methods
    
    func buildMenu() -> NSMenu {
        let topLevelMenu = NSMenu()
        
        topLevelMenu.addItem(self.buildCreateSleepTimerMenuItem())
        topLevelMenu.addItem(self.buildMinutesMenuItem())
        topLevelMenu.addItem(self.buildhoursMenuItem())
        topLevelMenu.addItem(self.buildUntilItem())
        topLevelMenu.addItem(self.buildWhileRunningItem())
        
        topLevelMenu.addItem(NSMenuItem.separator())
        
        topLevelMenu.addItem(self.buildQuitItem())
        
        return topLevelMenu
    }
    
    // MARK: - Private Methods
    
    private func buildCreateSleepTimerMenuItem() -> NSMenuItem {
        return NSMenuItem.withBoldTitle(title: "Create Sleep Timer:", action: nil, keyEquivalent: "")
    }
    
    private func buildMinutesMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem(title: "Minutes", action: nil, keyEquivalent: "")
        menuItem.indentationLevel = 1
        menuItem.submenu = NSMenu()
        
        for minutes in ((1..<60).filter { $0 % 5 == 0 }) {
            let item = GNActionableMenuItem(title: "\(minutes) Minutes", keyEquivalent: "") {
                print(GNSleepTimer.forMinutes(minutes))
            }
            
            menuItem.submenu!.addItem(item)
            
            if minutes % 10 == 0 {
                item.keyEquivalent = "\(minutes / 10)"
                item.keyEquivalentModifierMask = [.command]
            } else if minutes > 5 && minutes % 5 == 0 {
                item.keyEquivalent = "\(minutes / 10)"
                item.keyEquivalentModifierMask = [.command, .option]
            } else {
                item.keyEquivalent = "0"
            }
            
            if (minutes - 5) % 10 == 0 {
                menuItem.submenu!.addItem(NSMenuItem.separator())
            }
        }
        
        return menuItem
    }
    
    private func buildhoursMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem(title: "Hours", action: nil, keyEquivalent: "")
        menuItem.indentationLevel = 1
        menuItem.submenu = NSMenu()
        
        for hours in (1...5) {
            let item = GNActionableMenuItem(title: "\(hours) \(hours == 1 ? "Hour" : "Hours")", keyEquivalent: "\(hours)") {
                print(GNSleepTimer.forHours(hours))
            }
            item.keyEquivalentModifierMask = [.command, .shift]
            
            menuItem.submenu!.addItem(item)
        }
        
        return menuItem
    }
    
    private func buildUntilItem() -> NSMenuItem {
        let item = GNActionableMenuItem(title: "Until...", keyEquivalent: "u") {
            print(GNSleepTimer.until(Date()))
        }
        item.indentationLevel = 1
        
        return item
    }
    
    private func buildWhileRunningItem() -> NSMenuItem {
        let item = GNActionableMenuItem(title: "While App Is Running...", keyEquivalent: "a") {
            self.popoverManager.open()
            print("Running")
        }
        item.indentationLevel = 1
        
        return item
    }
    
    private func buildQuitItem() -> NSMenuItem {
        let item = GNActionableMenuItem(title: "Quit Goodnight", keyEquivalent: "u") {
            NSApp.terminate(self)
        }
        
        return item
    }
    
}

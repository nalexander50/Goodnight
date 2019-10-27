//
//  GNStatusBarMenuService.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa

class GNStatusBarMenuService {
    
    // MARK: - Key Equivalents

    /// Specifies the key equivalents for various operations.
    enum KeyEquivalents: String {
        case seconds = "s"
        case untilDate = "u"
        case whileBatteryAbove = "b"
        case whileAppRunning = "a"
        case preferences = ","
        case quit = "q"
    }
    
    // MARK: Properties

    private var sleepTimerStream: GNSleepTimerTwoWayStream
    
    // MARK: Initializer
    
    init(sleepTimerStream stream: GNSleepTimerTwoWayStream) {
        self.sleepTimerStream = stream
    }
    
    // MARK: - Public Methods
    
    func buildMenu() -> NSMenu {
        let topLevelMenu = NSMenu()

        topLevelMenu.addItem(self.buildCreateSleepTimerMenuItem())
        topLevelMenu.addItem(self.buildSecondsMenuItem())
        topLevelMenu.addItem(self.buildMinutesMenuItem())
        topLevelMenu.addItem(self.buildhoursMenuItem())
        topLevelMenu.addItem(self.buildUntilMenuItem())
        topLevelMenu.addItem(self.buildBatteryLevelMenuItem())
        topLevelMenu.addItem(self.buildWhileRunningMenuItem())

        topLevelMenu.addItem(NSMenuItem.separator())

        topLevelMenu.addItem(self.buildPreferencesMenuItem())
        topLevelMenu.addItem(self.buildAboutMenuItem())

        topLevelMenu.addItem(NSMenuItem.separator())

        topLevelMenu.addItem(self.buildQuitMenuItem())

        return topLevelMenu
    }
    
    // MARK: - Private Methods
    
    /**
     Creates the 'Create Sleep Timer' top-level menu.

     - Returns: 'Create Sleep Timer' top-level menu.
     */
    private func buildCreateSleepTimerMenuItem() -> NSMenuItem {
        return NSMenuItem.withBoldTitle(title: "Create Sleep Timer:", action: nil, keyEquivalent: "")
    }
    
    /**
    Creates the '10 Seconds' menu. If selected, a sleep timer is started counting down 10 seconds. After the timer resolves, the device will sleep.

    - Returns: '10 Seconds' menu.
    */
    private func buildSecondsMenuItem() -> NSMenuItem {
        let item = GNActionableMenuItem(title: "10 Seconds", keyEquivalent: KeyEquivalents.seconds.rawValue) {
            self.sleepTimerStream.send(.debugAfterSeconds(10))
        }
        item.indentationLevel = 1

        return item
     }
    
    /**
    Creates the 'Minutes' menu and submenu items for every 5 minute increment between 0 and 60 minutes. If a minute option is selected, a sleep timer is started counting down the selected number of minutes. After the timer resolves, the device will sleep.

    - Returns: 'Minutes' menu.
    */
   private func buildMinutesMenuItem() -> NSMenuItem {
       let menuItem = NSMenuItem(title: "Minutes", action: nil, keyEquivalent: "")
       menuItem.indentationLevel = 1
       menuItem.submenu = NSMenu()

       for minutes in ((1..<60).filter { $0 % 5 == 0 }) {
           let item = GNActionableMenuItem(title: "\(minutes) Minutes", keyEquivalent: "") {
               self.sleepTimerStream.send(.afterMinutes(minutes))
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

   /**
   Creates the 'Hours' menu and submenu items for every hour increment between 0 and 5 hours. If an hour option is selected, a sleep timer is started counting down the selected number of hours. After the timer resolves, the device will sleep.

   - Returns: 'Hours' menu.
   */
   private func buildhoursMenuItem() -> NSMenuItem {
       let menuItem = NSMenuItem(title: "Hours", action: nil, keyEquivalent: "")
       menuItem.indentationLevel = 1
       menuItem.submenu = NSMenu()

       for hours in (1...5) {
           let item = GNActionableMenuItem(title: "\(hours) \(hours == 1 ? "Hour" : "Hours")", keyEquivalent: "\(hours)") {
               
           }
           item.keyEquivalentModifierMask = [.command, .shift]

           menuItem.submenu!.addItem(item)
       }

       return menuItem
   }

   /**
    Creates the 'Until...' menu item. When chosen, displays a user interface in a popover allowing the user to select a date. If a date is selected, a sleep timer is started counting down to the selected date. After the timer resolves, the device will sleep.

    - Returns: 'Until' menu item.
    */
   private func buildUntilMenuItem() -> NSMenuItem {
       let item = GNActionableMenuItem(title: "Until...", keyEquivalent: KeyEquivalents.untilDate.rawValue) {
           
       }
       item.indentationLevel = 1

       return item
    }
    
    /**
    Creates the 'While Battery Above'...' menu item. When chosen, displays a user interface in a popover allowing the user to select a battery percentage. If a battery percentage is selected, a sleep timer is started counting down to the selected battery percentage. After the timer resolves, the device will sleep.

    - Returns: 'Until' menu item.
    */
    private func buildBatteryLevelMenuItem() -> NSMenuItem {
        let item = GNActionableMenuItem(title: "While Battery Above...", keyEquivalent: KeyEquivalents.whileBatteryAbove.rawValue) {
            self.sleepTimerStream.send(.whileBatteryAbove(percentage: 46))
        }
        item.indentationLevel = 1

        return item
    }

   /**
   Creates the 'While App Is Running...'' menu item. When chosen, displays a user interface in a popover allowing the user to select an application. If an application is selected, a sleep timer is started waiting for the application to termiante. After the timer resolves, the device will sleep.

   - Returns: 'While App Is Running' menu item.
   */
   private func buildWhileRunningMenuItem() -> NSMenuItem {
       let item = GNActionableMenuItem(title: "While App Is Running...", keyEquivalent: KeyEquivalents.whileAppRunning.rawValue) {
           
       }
       item.indentationLevel = 1

       return item
   }

   /**
   Creates the 'About' menu item. When chosen, displays a user interface in a popover showing information about Goodnight.

   - Returns: 'About' menu item.
   */
   private func buildAboutMenuItem() -> NSMenuItem {
       let aboutItem = GNActionableMenuItem(title: "About Goodnight", keyEquivalent: "") {
        
       }

       return aboutItem
   }

   /**
   Creates the 'Preferences' menu item. When chosen, displays a user interface in a popover allowing preferences to be modified.

   - Returns: 'Preferences' menu item.
   */
   private func buildPreferencesMenuItem() -> NSMenuItem {
       let prefItem = GNActionableMenuItem(title: "Preferences...", keyEquivalent: KeyEquivalents.preferences.rawValue) {
           
       }

       return prefItem
   }

   /**
   Creates the 'Quit' menu item. When chosen, quits Goodnight.

   - Returns: 'Quit' menu item.
   */
   private func buildQuitMenuItem() -> NSMenuItem {
       let item = GNActionableMenuItem(title: "Quit Goodnight", keyEquivalent: KeyEquivalents.quit.rawValue) {
           NSApp.terminate(self)
       }

       return item
   }

}

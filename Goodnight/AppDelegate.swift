//
//  AppDelegate.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties

    private var statusItemMenuManager: StatusItemMenuManager!
    private var subscription: AnyCancellable!
    
    // MARK: - NSApplicationDelegate

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let subject = PassthroughSubject<GNUserInterfaceEvent, Never>()
        self.statusItemMenuManager = StatusItemMenuManager(subject: subject)
        self.statusItemMenuManager.buildMenu()
                
        let responder = GNUserInterfaceResponder(forSubject: subject)
        
        self.subscription = subject.sink { event in
            print(event)
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        
    }
    
    deinit {
        self.subscription?.cancel()
    }

}

enum GNUserInterfaceEvent {
    case statusItemClicked
    case minutesItemClicked(minutes: Int)
    
    #if DEBUG
    case secondsItemClicked(seconds: Int)
    #endif
}

protocol GNUserInterfaceResponding {
        
    func selected(minutes: Int)
    func selected(hours: Int)
    func selected(date: Date)
    func selected(batteryAbove percentage: Int)
    func selected(runningApp: NSRunningApplication)
    func selectedAbout()
    func selectedPreferences()
    
    #if DEBUG
    func debugSelected(seconds: Int)
    #endif
}

class GNUserInterfaceResponder: GNUserInterfaceResponding {
    
    private var subscription: AnyCancellable? = nil
    
    init(forSubject subject: PassthroughSubject<GNUserInterfaceEvent, Never>) {
        self.subscription = subject.sink { event in
            switch event {
                
            case .statusItemClicked:
                return
            case .minutesItemClicked(let minutes):
                self.selected(minutes: minutes)
            #if DEBUG
            case .secondsItemClicked(let seconds):
                self.debugSelected(seconds: seconds)
            #endif
            @unknown default:
                return
            }
        }
    }
    
    deinit {
        self.subscription?.cancel()
    }
    
    func selected(minutes: Int) {
        print("\(minutes) Minutes")
    }
    
    func selected(hours: Int) {
        print("\(hours) Hours")
    }
    
    func selected(date: Date) {
        print("Until \(date.description)")
        
    }
    
    func selected(batteryAbove percentage: Int) {
        print("\(percentage)%")
    }
    
    func selected(runningApp: NSRunningApplication) {
        print("While \(runningApp.localizedName ?? "?")")
    }
    
    func selectedAbout() {
        print("About")
    }
    
    func selectedPreferences() {
        print("Preferences")
    }
    
    #if DEBUG
    func debugSelected(seconds: Int) {
        print("\(seconds) Seconds")
    }
    #endif
    
}

class StatusItemMenuManager {
    
    private let subject: PassthroughSubject<GNUserInterfaceEvent, Never>
    private let statusItem: NSStatusItem
    
    init(subject: PassthroughSubject<GNUserInterfaceEvent, Never>) {
        self.subject = subject
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusItem.button?.title = "💤"
        self.statusItem.button?.target = self
        self.statusItem.button?.action = #selector(self.buttonAction)
    }
    
    func buildMenu() {
        self.statusItem.button?.target = nil
        self.statusItem.button?.action = nil
        
        let topLevelMenu = NSMenu()
        topLevelMenu.addItem(NSMenuItem.withBoldTitle(title: "Create Sleep Timer:", action: nil, keyEquivalent: ""))
        #if DEBUG
        topLevelMenu.addItem(self.buildSecondsMenuItem())
        #endif
        topLevelMenu.addItem(self.buildMinutesMenuItem())
        
        self.statusItem.menu = topLevelMenu
    }
    
    func removeMenu() {
        self.statusItem.menu = nil
        self.statusItem.button?.target = self
        self.statusItem.button?.action = #selector(self.buttonAction)
    }
    
    @objc private func buttonAction() {
        self.subject.send(.statusItemClicked)
    }
    
    #if DEBUG
    private func buildSecondsMenuItem() -> NSMenuItem {
        let menuItem = GNActionableMenuItem(title: "Seconds", keyEquivalent: "") {
            self.subject.send(.secondsItemClicked(seconds: 10))
        }
        menuItem.indentationLevel = 1
        return menuItem
    }
    #endif
    
    private func buildMinutesMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem(title: "Minutes", action: nil, keyEquivalent: "")
        menuItem.indentationLevel = 1
        menuItem.submenu = NSMenu()
        
        for minutes in ((1..<60).filter { $0 % 5 == 0 }) {
            let item = GNActionableMenuItem(title: "\(minutes) Minutes", keyEquivalent: "") {
                self.subject.send(.minutesItemClicked(minutes: minutes))
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
    
}

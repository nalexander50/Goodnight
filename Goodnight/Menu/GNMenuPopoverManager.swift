//
//  MenuPopoverManager.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/10/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

/// Utility for providing a popover user interface.
class GNMenuPopoverManager {
    
    // MARK: - Properties
    
    var popover: NSPopover
    private var anchor: NSView
    
    // MARK: - Initializers
    
    /**
     Creates a new popover manager with the popover anchored to the specified view. Inside the popover, a hosting controller presents a SwiftUI view.
     
     - Parameter anchor: View to which the popover will be anchored.
     - Parameter content: SwiftUI view to be displayed inside the popover
     */
    init<Content>(anchoredTo anchor: NSView, withContent content: Content) where Content: View {
        self.anchor = anchor
        self.popover = NSPopover()
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: content)
    }
    
    // MARK: - Public Methods
    
    /**
     If the popover is open, closes the popover. If the popover is closed, opens the popover. If the popover is opened, the app is activated amd focused.
     */
    @objc func toggle() {
        if self.popover.isShown {
            self.close()
        } else {
            self.open()
        }
    }
    
    /**
     Opens the popover and actives the application.
     */
    func open() {
        if self.popover.isShown {
            return
        }
        self.popover.show(relativeTo: .zero, of: self.anchor, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    /**
     Closes the popover.
     */
    func close() {
        if !self.popover.isShown {
            return
        }
        self.popover.performClose(nil)
    }
    
}

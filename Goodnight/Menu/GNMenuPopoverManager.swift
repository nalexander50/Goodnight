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

class GNMenuPopoverManager {
    
    // MARK: - Properties
    
    var popover: NSPopover
    private var anchor: NSView
    
    // MARK: - Initializers
    
    init(anchoredTo anchor: NSView) {
        self.anchor = anchor
        self.popover = NSPopover()
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: MenuBarPopoverView())
    }
    
    // MARK: - Public Methods
    
    @objc func toggle() {
        if self.popover.isShown {
            self.close()
        } else {
            self.open()
        }
    }
    
    func open() {
        if self.popover.isShown {
            return
        }
        self.popover.show(relativeTo: .zero, of: self.anchor, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func close() {
        if !self.popover.isShown {
            return
        }
        self.popover.performClose(nil)
    }
    
}

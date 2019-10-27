//
//  GNActionableMenuItem.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa

/// A NSMenuItem that accepts an action closure
class GNActionableMenuItem: NSMenuItem {
    
    // MARK: - Type Aliases
    
    typealias ActionClosure = () -> ()
    
    // MARK: - Properties
    
    private var actionClosure: ActionClosure?
    
    // MARK: - Initializers
    
    /**
     Creates a new menu item with the specified title, key equivalent, and action closure. The action closure is executed when the menu item is selected.
     
     - Parameter title: Title of the menu item.
     - Parameter keyEquivalent: Key equivalent for the menu item.
     - Parameter action: Closure to be executed when the menu item is selected.
     */
    init(title: String, keyEquivalent: String, action closure: ActionClosure?) {
        self.actionClosure = closure
        super.init(title: title, action: #selector(self.performAction), keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    /**
     Not Implemented.
     */
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /**
     Executes the provided action closure. This method must exist because `NSMenuItem` requires an action selector.
     */
    @objc private func performAction() {
        self.actionClosure?()
    }
    
}

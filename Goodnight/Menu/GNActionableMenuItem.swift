//
//  NSMenuItem+Closure.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/10/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa

class GNActionableMenuItem: NSMenuItem {
    
    // MARK: - Type Aliases
    
    typealias ActionClosure = () -> ()
    
    // MARK: - Properties
    
    private var actionClosure: ActionClosure?
    
    // MARK: - Initializers
    
    init(title: String, keyEquivalent: String, action closure: ActionClosure?) {
        self.actionClosure = closure
        super.init(title: title, action: #selector(self.performAction), keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    @objc private func performAction() {
        self.actionClosure?()
    }
    
}

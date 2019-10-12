//
//  NSMenu+ActionableMenuItem.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/10/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import AppKit

extension NSMenu {
    
    typealias ActionClosure = () -> ()
    
    func addItem(withTitle title: String, keyEquivalent: String, action closure: ActionClosure?) {
        self.addItem(GNActionableMenuItem(title: title, keyEquivalent: keyEquivalent, action: closure))
    }
    
}

//
//  NSMenuItem+NSAttributedString.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/27/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa

extension NSMenuItem {
    
    convenience init(attributedTitle: NSAttributedString) {
        self.init()
        self.attributedTitle = attributedTitle
    }
    
    convenience init(attributedTitle: NSAttributedString, action: Selector?, keyEquivalent: String) {
        self.init()
        self.attributedTitle = attributedTitle
        self.action = action
        self.keyEquivalent = keyEquivalent
    }
    
    static func withBoldTitle(title: String, action: Selector?, keyEquivalent: String) -> NSMenuItem {
        let systemMenuFontSize: CGFloat = NSFont.menuFont(ofSize: 0).pointSize
        let attributedString = NSAttributedString(string: title, attributes: [
            .font: NSFont.boldSystemFont(ofSize: systemMenuFontSize),
            .foregroundColor: NSColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        ])
        return NSMenuItem(attributedTitle: attributedString, action: action, keyEquivalent: keyEquivalent)
    }
    
}

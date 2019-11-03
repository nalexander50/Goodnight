//
//  NSPopover+NSHostingController.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import AppKit
import Foundation
import SwiftUI

extension NSPopover {
    convenience init<Content>(hostingController: NSHostingController<Content>) where Content: View {
        self.init()
        contentViewController = hostingController
    }
}

//
//  PopoverService.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/31/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Combine
import Foundation
import SwiftUI

class PopoverService: GNStatusItemPopoverSender, GNStatusItemPopoverReceiver {

    // MARK: - Initializers

    private init() {

    }

    // MARK: Public Methods

    static func popoverCountingDownTo(_ fireDate: Date) -> NSPopover {
        let countdownViewModel = GNCountdownViewModel(targetDate: fireDate)
        let countdownView = GNCountdownView(viewModel: countdownViewModel)

        let popover = NSPopover(hostingController: NSHostingController(rootView: countdownView))
        return popover
    }

    static func popoverDatePicker() -> NSPopover {
        let datePickerViewModel = GNDatePickerViewModel()
        let datePickerView = GNDatePickerView(viewModel: datePickerViewModel)
        let popover = NSPopover(hostingController: NSHostingController(rootView: datePickerView))
        return popover
    }
}

//
//  GNStatusItemPopoverService.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Combine

class GNStatusItemPopoverService: GNStatusItemPopoverReceiver {

    // MARK: - Properties

    private var popover: NSPopover?
    private var popoverSubscription: AnyCancellable?

    // MARK: - Initializers

    init() {
        self.popoverSubscription = self.popoverReceiverStream.sink { popover in
            self.popover?.performClose(self)
            self.popover = popover
        }
    }

    deinit {
        self.popoverSubscription?.cancel()
    }

    // MARK: - Public Methods

    func showPopover(anchoredTo anchor: NSView) {
        if let popover = self.popover {
            if !popover.isShown {
                popover.show(relativeTo: .zero, of: anchor, preferredEdge: .minY)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    func closePopover() {
        if let popover = self.popover {
            if popover.isShown {
                popover.performClose(self)
            }
        }
    }

}

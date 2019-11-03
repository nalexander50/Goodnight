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

    private let anchor: NSView

    private var popover: NSPopover?
    private var popoverSubscription: AnyCancellable?

    // MARK: - Initializers

    init(anchoredTo anchor: NSView) {
        self.anchor = anchor
        self.popoverSubscription = popoverReceiverStream.sink(receiveValue: self.onNewPopover)
    }

    deinit {
        self.popoverSubscription?.cancel()
    }

    // MARK: - Public Methods

    func showPopover() {
        if let popover = self.popover {
            if !popover.isShown {
                popover.show(relativeTo: .zero, of: self.anchor, preferredEdge: .minY)
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

    // MARK: - Private Methods

    private func onNewPopover(popover: NSPopover?, requestedState: GNPopoverState) {
        self.popover?.performClose(self)
        self.popover = popover

        switch requestedState {
            case .open:
                self.popover?.show(relativeTo: .zero, of: self.anchor, preferredEdge: .minY)
            case .close:
                self.popover?.performClose(self)
        }
    }
}

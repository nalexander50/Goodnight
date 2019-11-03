//
//  GNStatusItemService.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Combine
import Foundation

class GNStatusItemService: GNStatusItemPopoverSender, GNStatusItemPopoverReceiver, GNSleepConditionsReceiver {

    // MARK: - Properties

    private let statusItem: NSStatusItem
    private let statusBarMenuService: GNStatusBarMenuService
    private let popoverService: GNStatusItemPopoverService

    private var isSleepScheduled: Bool = false
    private var popoverSubscription: AnyCancellable?
    private var sleepConditionsSubscription: AnyCancellable?

    // MARK: - Initializers

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarMenuService = GNStatusBarMenuService()
        self.popoverService = GNStatusItemPopoverService(anchoredTo: self.statusItem.button!)

        self.popoverSubscription = self.popoverReceiverStream.sink(receiveValue: self.onNewPopover)
        self.sleepConditionsSubscription = self.sleepConditionsReceiverStream.sink { self.isSleepScheduled = $0 != nil }
        self.customizeStatusItem()
    }

    deinit {
        self.popoverSubscription?.cancel()
    }

    // MARK: - Public Methods

    func resignActive() {
        self.popoverService.closePopover()
        if !self.isSleepScheduled { // avoid closing the countdown view
            self.popoverSenderStream.send((nil, .close))
        }
    }

    // MARK: - Private Methods

    private func customizeStatusItem() {
        self.statusItem.button?.title = "💤"
    }

    @objc private func statusItemButtonAction() {
        self.popoverService.showPopover()
    }

    private func onNewPopover(popover: NSPopover?, requestedState: GNPopoverState) {
        if popover == nil {
            self.statusItem.menu = self.statusBarMenuService.buildMenu()
            self.statusItem.button?.target = nil
            self.statusItem.button?.action = nil
        } else {
            self.statusItem.menu = nil
            self.statusItem.button?.target = self
            self.statusItem.button?.action = #selector(self.statusItemButtonAction)

            switch requestedState {
                case .open:
                    self.popoverService.showPopover()
                case .close:
                    self.popoverService.closePopover()
            }
        }
    }
}

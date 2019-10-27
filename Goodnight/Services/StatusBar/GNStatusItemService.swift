//
//  GNStatusItemService.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa
import Combine

class GNStatusItemService {
    
    // MARK: - Properties
    
    private let statusItem: NSStatusItem
    private let statusBarMenuService: GNStatusBarMenuService
    private let popoverService: GNStatusItemPopoverService
    private var popoverSubscription: AnyCancellable?
    
    // MARK: - Initializers
    
    init(popoverStream: GNPopoverStream, sleepTimerStream: GNSleepTimerTwoWayStream) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarMenuService = GNStatusBarMenuService(sleepTimerStream: sleepTimerStream)
        self.popoverService = GNStatusItemPopoverService(popoverStream: popoverStream)
        
        self.popoverSubscription = popoverStream.sink(receiveValue: self.onNewPopover)
        self.customizeStatusItem()
    }
    
    deinit {
        self.popoverSubscription?.cancel()
    }
    
    // MARK: - Public Methods
    
    func resignActive() {
        self.popoverService.closePopover()
    }
    
    // MARK: - Private Methods
    
    private func customizeStatusItem() {
        self.statusItem.button?.title = "💤"
    }
    
    @objc private func statusItemButtonAction() {
        self.popoverService.showPopover(anchoredTo: self.statusItem.button!)
    }
    
    private func onNewPopover(popover: NSPopover?) {
        if popover == nil {
            self.statusItem.menu = self.statusBarMenuService.buildMenu()
            self.statusItem.button?.target = nil
            self.statusItem.button?.action = nil
        } else {
            self.statusItem.menu = nil
            self.statusItem.button?.target = self
            self.statusItem.button?.action = #selector(self.statusItemButtonAction)
        }
    }
    
}

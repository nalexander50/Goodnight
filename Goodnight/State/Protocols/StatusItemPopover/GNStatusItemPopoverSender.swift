//
//  GNStatusItemPopoverSender.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import AppKit
import Combine

// MARK: - Type Alias

typealias GNStatusItemPopoverSenderStream = CurrentValueSubject<(popover: NSPopover?, requestedState: GNPopoverState), Never>

// MARK: - Protocol

protocol GNStatusItemPopoverSender {
    var popoverSenderStream: GNStatusItemPopoverSenderStream { get }
}

// MARK: - Extension

extension GNStatusItemPopoverSender {
    var popoverSenderStream: GNStatusItemPopoverSenderStream {
        return GNStreams.statusItemPopoverSenderStream
    }
}

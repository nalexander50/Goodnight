//
//  GNStatusItemPopoverReceiver.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import AppKit
import Combine

// MARK: - Type Alias

typealias GNStatusItemPopoverReceiverStream = AnyPublisher<NSPopover?, Never>

// MARK: - Protocol

protocol GNStatusItemPopoverReceiver {
    var popoverReceiverStream: GNStatusItemPopoverReceiverStream { get }
}

// MARK: - Extension

extension GNStatusItemPopoverReceiver {
    var popoverReceiverStream: GNStatusItemPopoverReceiverStream {
        return GNStreams.statusItemPopoverReceiverStream
    }
}

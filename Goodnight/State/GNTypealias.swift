//
//  GNTypealias.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa
import Combine

typealias GNPopoverTwoWayStream = CurrentValueSubject<NSPopover?, Never>
typealias GNPopoverStream = AnyPublisher<NSPopover?, Never>

typealias GNSleepTimerTwoWayStream = CurrentValueSubject<GNSleepTimer?, Never>
typealias GNSleepTimerStream = AnyPublisher<GNSleepTimer?, Never>

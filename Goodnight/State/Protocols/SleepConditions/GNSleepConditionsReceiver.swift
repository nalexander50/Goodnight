//
//  GNSleepConditionsReceiver.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Combine

// MARK: - Type Alias

typealias GNSleepConditionsReceiverStream = AnyPublisher<GNSleepConditions?, Never>

// MARK: - Protocol

protocol GNSleepConditionsReceiver {
    var sleepConditionsReceiverStream: GNSleepConditionsReceiverStream { get }
}

// MARK: - Extension

extension GNSleepConditionsReceiver {
    var sleepConditionsReceiverStream: GNSleepConditionsReceiverStream {
        return GNStreams.sleepConditionsReceiverStream
    }
}

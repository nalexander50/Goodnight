//
//  GNSleepConditionsSender.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/2/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Combine

// MARK: - Type Alias

typealias GNSleepConditionsSenderStream = CurrentValueSubject<GNSleepConditions?, Never>

// MARK: - Protocol

protocol GNSleepConditionsSender {
    var sleepConditionsSenderStream: GNSleepConditionsSenderStream { get }
}

// MARK: - Extension

extension GNSleepConditionsSender {
    var sleepConditionsSenderStream: GNSleepConditionsSenderStream {
        return GNStreams.sleepConditionsSenderStream
    }
}

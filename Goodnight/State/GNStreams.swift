//
//  GNStreams.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Cocoa
import Combine
import Foundation

class GNStreams {

    // MARK: Initializers

    private init() {

    }

    // MARK: Subjects

    static var statusItemPopoverSenderStream: GNStatusItemPopoverSenderStream = {
        GNStatusItemPopoverSenderStream(nil)
    }()

    static var statusItemPopoverReceiverStream: GNStatusItemPopoverReceiverStream = {
        GNStreams.statusItemPopoverSenderStream.eraseToAnyPublisher()
    }()

    static var sleepConditionsSenderStream: GNSleepConditionsSenderStream = {
        GNSleepConditionsSenderStream(nil)
    }()

    static var sleepConditionsReceiverStream: GNSleepConditionsReceiverStream = {
        GNStreams.sleepConditionsSenderStream.eraseToAnyPublisher()
    }()

}

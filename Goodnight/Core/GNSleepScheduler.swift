//
//  GNSleepScheduler.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/26/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import AppKit
import Combine
import Foundation

class GNSleepScheduler: GNSleepConditionsSender, GNSleepConditionsReceiver, GNStatusItemPopoverSender {

    // MARK: Properties

    var scheduledSleep: GNScheduledSleep?
    private var conditionsSubscription: AnyCancellable?

    // MARK: Initializers

    init() {
        self.conditionsSubscription = sleepConditionsReceiverStream.sink(receiveValue: self.onNewSleepTimer)
    }

    deinit {
        self.conditionsSubscription?.cancel()
    }

    // MARK: Public Methods

    func scheduleSleep(after conditions: GNSleepConditions) {
        self.cancelScheduledSleep()

        let factory = GNTimerFactory(withConditions: conditions) { _ in
            self.sleep()
        }

        let (fireDate, timer) = factory.createTimer()
        self.scheduledSleep = GNScheduledSleep(fireDate: fireDate, timer: timer, conditions: conditions)
        RunLoop.current.add(timer, forMode: .common)
    }

    func cancelScheduledSleep() {
        self.scheduledSleep?.timer.invalidate()
        self.scheduledSleep = nil
        popoverSenderStream.send((nil, .close))
    }

    // MARK: Private Methods

    private func onNewSleepTimer(conditions: GNSleepConditions?) {
        if let conditions = conditions {
            self.scheduleSleep(after: conditions)

            // todo what about non-date-based timers?
            if let fireDate = self.scheduledSleep?.fireDate {
                let popover = PopoverService.popoverCountingDownTo(fireDate)
                popoverSenderStream.send((popover, .close))
            }
        } else {
            self.cancelScheduledSleep()
        }
    }

    private func sleep() {
        print("Goodnight")
        self.cancelScheduledSleep()
    }
}

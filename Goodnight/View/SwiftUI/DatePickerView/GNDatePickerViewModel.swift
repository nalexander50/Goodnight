//
//  GNDatePickerViewModel.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Combine
import Foundation

class GNDatePickerViewModel: ObservableObject, GNSleepConditionsSender {

    // MARK: - Initializers

    init() {}

    // MARK: Public Methods

    func createTimer(hours: Int, minutes: Int) {
        if hours == 0, minutes == 0 {
            return
        }

        let dateComponents = DateComponents(hour: hours, minute: minutes)
        if let fireDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
            sleepConditionsSenderStream.send(.afterDate(fireDate))
        }
    }

    func createTimer(fireDate: Date) {
        sleepConditionsSenderStream.send(.afterDate(fireDate))
    }
}

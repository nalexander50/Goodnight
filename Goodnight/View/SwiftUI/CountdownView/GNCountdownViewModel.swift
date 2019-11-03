//
//  GNCountdownViewModel.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/27/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class GNCountdownViewModel: ObservableObject, GNSleepConditionsSender {

    // MARK: - Properties

    private let targetDate: Date
    private var cancellableSet: Set<AnyCancellable>

    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 3
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowsFractionalUnits = false
        return formatter
    }()

    @Published var countdownMessage: String
    @Published var isFinished: Bool

    // MARK: - Initializers

    init(targetDate: Date) {
        self.cancellableSet = Set()
        self.targetDate = targetDate
        self.isFinished = Date() == targetDate
        self.countdownMessage = self.formatter.string(from: ceil(targetDate.timeIntervalSinceNow)) ?? "? hours, ? minutes, ? seconds"

        self.createPublishers()
    }

    deinit {
        for cancellable in self.cancellableSet {
            cancellable.cancel()
        }
    }

    // MARK: Public Methods

    func cancelSleepTimer() {
        self.sleepConditionsSenderStream.send(nil)
    }

    // MARK: - Private Methods

    private func createPublishers() {
        let countdownPublisher = Timer.publish(every: 1.0, tolerance: 0.0, on: .current, in: .default).autoconnect()

        countdownPublisher.map { now in
            now >= self.targetDate
        }
        .assign(to: \GNCountdownViewModel.isFinished, on: self)
        .store(in: &self.cancellableSet)

        countdownPublisher.map { _ in
            self.formatter.string(from: ceil(self.targetDate.timeIntervalSinceNow)) ?? "? hours, ? minutes, ? seconds"
        }
        .assign(to: \GNCountdownViewModel.countdownMessage, on: self)
        .store(in: &self.cancellableSet)

        self.cancellableSet.insert($isFinished.removeDuplicates().sink { finished in
            if finished {
                for cancellable in self.cancellableSet {
                    cancellable.cancel()
                }
            }
        })
    }

}

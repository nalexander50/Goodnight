//
//  GNCountdownViewModel.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/27/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class GNCountdownViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let targetDate: Date
    private var cancellableSet: Set<AnyCancellable>
    
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 3
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowsFractionalUnits = false
        return formatter
    }()
    
    @Published var countdownMessage: String
    @Published var isFinished: Bool
    
    // MARK: - Initializers
    
    init(toDate targetDate: Date) {
        self.targetDate = targetDate
        self.countdownMessage = ""
        self.isFinished = Date() == targetDate
        self.cancellableSet = Set()
        
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
        // todo
        GNStreams.sleepTimerTwoWayStream.send(nil)
    }
    
    // MARK: - Private Methods
    
    private func createPublishers() {
        let countdownPublisher = Timer.publish(every: 1.0, tolerance: 0.0, on: .current, in: .default).autoconnect()

        countdownPublisher.map { now in
            return now >= self.targetDate
        }
        .assign(to: \GNCountdownViewModel.isFinished, on: self)
        .store(in: &self.cancellableSet)
        
        countdownPublisher.map { _ in
            return self.formatter.string(from: ceil(self.targetDate.timeIntervalSinceNow)) ?? "? hours, ? minutes, ? seconds"
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

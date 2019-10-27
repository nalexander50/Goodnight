//
//  GNStreams.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/20/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation
import Cocoa
import Combine

class GNStreams {
    
    // MARK: Initializers
    
    private init() {
        
    }
    
    // MARK: Subjects
    
    static var statusItemPopoverTwoWayStream: GNPopoverTwoWayStream = {
        return GNPopoverTwoWayStream(nil)
    }()
    
    static var statusItemPopoverStream: GNPopoverStream = {
        return GNStreams.statusItemPopoverTwoWayStream.eraseToAnyPublisher()
    }()
    
    static var sleepTimerTwoWayStream: GNSleepTimerTwoWayStream = {
        return GNSleepTimerTwoWayStream(nil)
    }()
    
    static var sleepTimerStream: GNSleepTimerStream = {
        return GNStreams.sleepTimerTwoWayStream.eraseToAnyPublisher()
    }()
    
}

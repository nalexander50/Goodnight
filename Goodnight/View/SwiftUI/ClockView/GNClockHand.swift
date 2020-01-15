//
//  GNClockHand.swift
//  Goodnight
//
//  Created by Nick Alexander on 11/3/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import SwiftUI

enum GNClockHand {

    // MARK: - Cases

    case seconds
    case minutes
    case hours

    // MARK: - Properties

    var color: Color {
        switch self {
            case .seconds:
                return Color.green
            case .minutes:
                return Color.blue
            case .hours:
                return Color.red
        }
    }
    
    var thickness: CGFloat {
        switch self {
            case .seconds:
                return 1
            case .minutes:
                return 3
            case .hours:
                return 6
        }
    }

}

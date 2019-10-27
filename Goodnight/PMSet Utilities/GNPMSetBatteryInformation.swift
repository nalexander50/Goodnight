//
//  GNPMSetBatteryInformation.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/26/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

/**
 Represents the battery information output from the `pmset` utility.
 
 In general, the output from the following command should be used to initialize this struct.
 
 ```
 pmset -g batt
 ```
 
 The above command will return information for devices without an internal battery, but the information will be unremarkable.
 
 */
struct GNPMSetBatteryInformation {
    
    // MARK: - Enums
    
    /// Contains regular expression patterns for parsing output from the `pmset` utility
    enum Regex: String {
        case powerSourceBattery = "\\bBattery Power\\b"
        case powerSourceAC = "\\bAC Power\\b"
        
        case chargingStatusDischarging = "\\bdischarging\\b"
        case chargingStatusCharging = "\\bcharging\\b"
        case chargingStatusNotCharging = "\\bnot charging\\b"
        
        case batteryPercentageRemaining = "[0-9]{1,3}\\%"
        case batteryTimeRemaining = "[0-9]{0,3}\\:[0-9]{0,3} remaining"
    }
    
    /// Represents the device's current power source.
    enum PowerSource {
        case unknown
        case battery
        case ac
    }
    
    /// Represents the device's current charging status
    enum ChargingStatus {
        case unknown
        case discharging
        case charging
        case notCharging
    }
    
    // MARK: - Properties
    
    let powerSource: PowerSource
    let chargingStatus: ChargingStatus
    let batteryPercentage: Int
    let batteryTimeRemaining: TimeInterval
    
    // MARK: - Initializers
    
    /**
     Initializes Battery Information from the string output of the `pmset` utility.
     */
    init(fromOutput output: String) {
        self.powerSource = GNPMSetBatteryInformation.determinePowerSource(from: output)
        self.chargingStatus = GNPMSetBatteryInformation.determineChargingStatus(from: output)
        (self.batteryPercentage, self.batteryTimeRemaining) = GNPMSetBatteryInformation.determineBatteryLevel(from: output)
    }
    
    /**
     Initializes Battery Information from the raw data output of the `pmset` utility.
     */
    init?(fromOutput output: Data) {
        guard let stringOutput = String(data: output, encoding: .utf8) else {
            return nil
        }
        self.init(fromOutput: stringOutput)
    }
    
    // MARK: - Static PMSet Parsing Functions
    
    /**
     Determines the device's power source (battery, ac, etc.) from the string output of the `pmset` utility.
     
     - Parameter input: Output from the `pmset` utility
     - Returns: The current device power source.
     */
    private static func determinePowerSource(from input: String) -> PowerSource {
        if input.range(of: Regex.powerSourceBattery.rawValue, options: .regularExpression) != nil {
            return .battery
        } else if input.range(of: Regex.powerSourceAC.rawValue, options: .regularExpression) != nil {
            return .ac
        } else {
            return .unknown
        }
    }
    
    /**
    Determines the device's charging status from the string output of the `pmset` utility.
     
     - Parameter input: Putput from the `pmset` utility
     - Returns: The current device charging status.
    */
    private static func determineChargingStatus(from input: String) -> ChargingStatus {
        if input.range(of: Regex.chargingStatusDischarging.rawValue, options: .regularExpression) != nil {
            return .discharging
        } else if input.range(of: Regex.chargingStatusCharging.rawValue, options: .regularExpression) != nil {
            return .charging
        } else if input.range(of: Regex.chargingStatusNotCharging.rawValue, options: .regularExpression) != nil {
            return .notCharging
        } else {
            return .unknown
        }
    }
    
    /**
    Determines the device's battery percentage and time remaining from the string output of the `pmset` utility. If either value could not be determined, that value will be `0`.
     
     - Parameter input: Putput from the `pmset` utility
     - Returns: Both the current battery percentage and how much battery time is remaining. If either value could not be determined, that value will be `0`.
    */
    private static func determineBatteryLevel(from input: String) -> (Int, TimeInterval) {
        return (determineBatteryPercentage(from: input), determineBatteryTimeRemaining(from: input))
    }
    
    /**
    Determines the device's battery percentage from the string output of the `pmset` utility. If the percentage cannot be determined, returns `0`.
     
     - Parameter input: Output from the `pmset` utility
     - Returns: The current battery percentage. If the percentage cannot be determined, returns `0`.
     */
    private static func determineBatteryPercentage(from input: String) -> Int {
        if let range = input.range(of: Regex.batteryPercentageRemaining.rawValue, options: .regularExpression) {
            let normalizedSubstring = input[range].replacingOccurrences(of: "%", with: "")
            if let percentage = Int(normalizedSubstring) {
                return percentage
            }
        }
        
        return 0
    }
    
    /**
    Determines the device's battery time remaining from the string output of the `pmset` utility. If the time remaining cannot be determined, returns `0.0`
     
     - Parameter input: Output from the `pmset` utility
     - Returns:  Battery time is remaining. If the time reamining cannot be determined, returns `0.0`.
    */
    private static func determineBatteryTimeRemaining(from input: String) -> TimeInterval {
        if let range = input.range(of: Regex.batteryTimeRemaining.rawValue, options: .regularExpression) {
            let normalizedSubstring = input[range].replacingOccurrences(of: " remaining", with: "")
            let compValues = normalizedSubstring.split(separator: ":").map { Int($0) }.filter { $0 != nil }
            
            var dateComponents = DateComponents()
            
            if compValues.count == 1 {
                dateComponents.minute = compValues[0]
            } else if compValues.count == 2 {
                dateComponents.hour = compValues[0]
                dateComponents.minute = compValues[1]
            } else if compValues.count == 3 {
                dateComponents.day = compValues[0]
                dateComponents.hour = compValues[1]
                dateComponents.minute = compValues[2]
            }
            
            if let futureDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
                return abs(futureDate.timeIntervalSince(Date()))
            }
        }
        
        return 0.0
    }
    
}

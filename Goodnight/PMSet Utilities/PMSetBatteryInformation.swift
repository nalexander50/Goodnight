//
//  BatteryInformation.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

struct PMSetBatteryInformation {
    
    // MARK: - Enums
    
    enum Regex: String {
        case powerSourceBattery = "\\bBattery Power\\b"
        case powerSourceAC = "\\bAC Power\\b"
        
        case chargingStatusDischarging = "\\bdischarging\\b"
        case chargingStatusCharging = "\\bcharging\\b"
        case chargingStatusNotCharging = "\\bnot charging\\b"
        
        case batteryPercentageRemaining = "[0-9]{1,3}\\%"
        case batteryTimeRemaining = "[0-9]{0,3}\\:[0-9]{0,3} remaining"
    }
    
    enum PowerSource {
        case unknown
        case battery
        case ac
    }
    
    enum BatteryLevel {
        case unknown
        case critical(perctange: Int, timeRemaining: TimeInterval)
        case normal(perctange: Int, timeRemaining: TimeInterval)
        case full(perctange: Int, timeRemaining: TimeInterval)
    }
    
    enum ChargingStatus {
        case unknown
        case discharging
        case charging
        case notCharging
    }
    
    // MARK: - Properties
    
    public let powerSource: PowerSource
    public let batterylevel: BatteryLevel
    public let chargingStatus: ChargingStatus
    
    // MARK: - Initializers
    
    /**
     Initializes Battery Information from the string output of the `pmset` utility.
     */
    init(fromOutput output: String) {
        self.powerSource = PMSetBatteryInformation.determinePowerSource(from: output)
        self.chargingStatus = PMSetBatteryInformation.determineChargingStatus(from: output)
        self.batterylevel = PMSetBatteryInformation.determineBatteryLevel(from: output)
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
    
    // MARK: - Static Helper Functions
    
    private static func determinePowerSource(from input: String) -> PowerSource {
        if input.range(of: Regex.powerSourceBattery.rawValue, options: .regularExpression) != nil {
            return .battery
        } else if input.range(of: Regex.powerSourceAC.rawValue, options: .regularExpression) != nil {
            return .ac
        } else {
            return .unknown
        }
    }
    
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
    
    private static func determineBatteryLevel(from input: String) -> BatteryLevel {
        return .normal(perctange: 50, timeRemaining: 50)
    }
    
}

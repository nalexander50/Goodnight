//
//  PMSetInterface.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

class PMSetInterface {
    
    // MARK: - Constants
    
    private let executablePath = "/usr/bin/pmset"
    
    // MARK: - Properties
    
    private var standardOutputPipe: Pipe? = nil
    
    // MARK: - Private Methods
    
    private func createProcess(withArguments arguments: [String]) -> Process {
        self.standardOutputPipe = Pipe()
        
        let process = Process()
        process.launchPath = self.executablePath
        process.arguments = arguments
        process.standardOutput = self.standardOutputPipe
        return process
    }
    
    private func readProcessOutput() -> String? {
        guard let stdOut = self.standardOutputPipe else {
            return nil
        }
        
        let stdOutData = stdOut.fileHandleForReading.readDataToEndOfFile()
        if let stdOutString = String(data: stdOutData, encoding: .utf8) {
            return stdOutString
        } else {
            return nil
        }
    }
    
    // MARK: - Public Methods
    
    public func sleepNow() {
        let args = ["sleepnow"]
        let process = self.createProcess(withArguments: args)
        process.launch()
    }
    
    public func getBatteryStatus() -> PMSetBatteryInformation? {
        let args = ["-g", "batt"]
        let process = self.createProcess(withArguments: args)
        process.launch()
        process.waitUntilExit()
        
        if let output = self.readProcessOutput() {
            return PMSetBatteryInformation(fromOutput: output)
        } else {
            return nil
        }
    }
    
}

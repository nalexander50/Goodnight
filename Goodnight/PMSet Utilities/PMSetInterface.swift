//
//  PMSetInterface.swift
//  Goodnight
//
//  Created by Nick Alexander on 10/7/19.
//  Copyright © 2019 Nick Alexander. All rights reserved.
//

import Foundation

/// A Swift wrapper around the `pmset` command-line utility packaged with macOS.
class PMSetInterface {
    
    // MARK: - Constants
    
    /// File path to the `pmset` utility.
    private let executablePath = "/usr/bin/pmset"
    
    // MARK: - Properties
    
    private var standardOutputPipe: Pipe? = nil
    
    // MARK: - Private Methods
    
    /**
     Creates a new `pmset` process with the specified arguments.
     
     - Parameter arguments: Arguments to be passed to the `pmset` command.
     - Returns: A process representing a call to the `pmset` utility.
     */
    private func createProcess(withArguments arguments: [String]) -> Process {
        self.standardOutputPipe = Pipe()
        
        let process = Process()
        process.launchPath = self.executablePath
        process.arguments = arguments
        process.standardOutput = self.standardOutputPipe
        return process
    }
    
    /**
     Reads the raw process output from the standard output pipe and returns it as a string. If standard out was not piped or the data cannot be read, returns `nil`.
     
     - Returns: String output from the standard output pipe. If standard out was not piped or the data cannot be read, returns `nil`.
     */
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
    
    /**
     Executes the following command to instruct the device to sleep immediately:
     
     ```
     pmset sleepnow
     ```
     
     For more information, consult the man pages for the `pmset` utility.
     
     - Warning: The current device will immediately sleep.
     
     */
    func sleepNow() {
        let args = ["sleepnow"]
        let process = self.createProcess(withArguments: args)
        process.launch()
    }
    
    /**
     Executes the following command to get battery information for the current device:
     
     ```
     pmset -g batt
     ```
     
     If the battery information cannot be read, returns `nil`. For more information, consult the man pages for the `pmset` utility.
     
     - Returns: A structure representing the current device's battery information. If the battery information cannot be read, returns `nil`.
     - Warning: The `pmset` command runs synchronously and will block until the `pmset` process exits.
     */
    func getBatteryStatus() -> PMSetBatteryInformation? {
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

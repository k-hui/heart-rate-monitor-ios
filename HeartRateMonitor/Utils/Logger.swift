//
//  Logger.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

public class LoggerInstance {

    public enum Level: String, CaseIterable {
        case debug = "DEBUG"
        case error = "ERROR"
        case none = "NONE"

        var levelValue: Int {
            switch self {
            case .debug: return 1
            case .error: return 2
            case .none: return 3
            }
        }

        var logTag: String {
            return "[\(self.rawValue)]"
        }
    }

    // default value
    var level = Level.debug

    var isEnabled: Bool {
        return self.level.levelValue < Level.none.levelValue
    }

    init() {
        print("====== Logging Level ========")
        print("\(level.rawValue)")
        print("=============================")
    }

    public func setLevel(_ value: Level) {
        level = value
    }

    public func d(_ message: Any?, file: String = #file, line: Int = #line, function: String = #function) {
        log(.debug, message, file: file, line: line, function: function)
    }

    public func e(_ message: Any?, file: String = #file, line: Int = #line, function: String = #function) {
        log(.error, message, file: file, line: line, function: function)
    }

    public func d(_ message: Any?..., file: String = #file, line: Int = #line, function: String = #function) {
        log(.debug, message, file: file, line: line, function: function)
    }

    public func e(_ message: Any?..., file: String = #file, line: Int = #line, function: String = #function) {
        log(.error, message, file: file, line: line, function: function)
    }

    public func log(_ level: LoggerInstance.Level, _ message: Any?..., file: String, line: Int, function: String) {
        log(level, message, file: file, line: line, function: function)
    }

    public func log(_ level: LoggerInstance.Level, _ message: Any?, file: String, line: Int, function: String) {
        #if DEBUG
            if isEnabled {
                let content: String = message.map { String(describing: $0) } ?? "nil"
                print("\(localTime()) \(shorten(file: file, line: line)) \(function) \(level.logTag) " + content)
            }
        #endif
    }

    func shorten(file: String, line: Int) -> String {
        let filePathSplits = file.split(separator: "/")
        var filePath: String = ""

        for (index, path) in filePathSplits.enumerated() {
            if let p = path.first, filePathSplits.count > 2 && index < filePathSplits.count - 2 {
                filePath += "\(String(p).lowercased())/"
            } else if index == filePathSplits.count - 1 {
                filePath += "\(path)"
            } else {
                filePath += "\(path)/"
            }
        }

        return "\(filePath):\(line)"
    }

    func localTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }

}

// set to Global, align Android Style
public let Logger = LoggerInstance()

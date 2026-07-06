//
//  AppLogger.swift
//  Nearby
//
//  Created by soomin on 7/1/26.
//

import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? "com.dewby.Nearby"
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let lifecycle = OSLog(subsystem: subsystem, category: "Life Cycle")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let data = OSLog(subsystem: subsystem, category: "Data")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

enum LogLevel {
    case network(message: Any)
    case lifecycle(message: Any)
    case debug(message: Any)
    case data(message: Any)
    case error(error: Error, message: Any?)
    
    var category: String {
        switch self {
        case .network: return "Network"
        case .lifecycle: return "Life Cycle"
        case .debug: return "Debug"
        case .data: return "Data"
        case .error: return "Error"
        }
    }
    
    var shouldShowLogInRelease: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
}

struct AppLogger {
    private static var isDebugMode: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    private static func shouldShowLog(level: LogLevel) -> Bool {
        if isDebugMode { return true }
        return level.shouldShowLogInRelease
    }
    
    private static func log(level: LogLevel, file: String, function: String) {
        guard shouldShowLog(level: level) else { return }
        
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[\(fileName) -> \(function)]:"
        
        switch level {
        case .network(let message):
            logger.log("[🌐 Network] \(prefix) \(String(describing: message))")
            
        case .lifecycle(let message):
            logger.log("[🔄 Life Cycle] \(prefix) \(String(describing: message))")
            
        case .debug(let message):
            logger.debug("[🐛 Debug] \(prefix) \(String(describing: message))")
            
        case .data(let message):
            logger.info("[📊 Data] \(prefix) \(String(describing: message))")
            
        case .error(let error, let message):
            if let message {
                let description = error.localizedDescription
                logger.error("[❌ Error] \(prefix) \(String(describing: message)) | Reason: \(description)")
            } else {
                logger.error("[❌ Error] \(prefix) Reason: \(error.localizedDescription)")
            }
        }
    }
    
    static func network(_ message: Any, file: String = #file, function: String = #function) {
        log(level: .network(message: message), file: file, function: function)
    }
    
    static func lifecycle(_ message: Any, file: String = #file, function: String = #function) {
        log(level: .lifecycle(message: message), file: file, function: function)
    }
    
    static func debug(_ message: Any, file: String = #file, function: String = #function) {
        log(level: .debug(message: message), file: file, function: function)
    }
    
    static func data(_ message: Any, file: String = #file, function: String = #function) {
        log(level: .data(message: message), file: file, function: function)
    }
    
    static func error(_ error: Error, message: Any? = nil, file: String = #file, function: String = #function) {
        log(level: .error(error: error, message: message), file: file, function: function)
    }
}

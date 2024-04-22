import Foundation
import Combine
import os

// MARK: - log middleware
struct LogService {
    static let logger: Logger = Logger(subsystem: "de.selch.businessToGo", category: "businessToGo log")
    
    static func log(_ message: String){
        LogService.logger.log("\(message, privacy: .public)")
    }
}

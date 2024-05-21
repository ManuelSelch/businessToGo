
import Foundation

struct MyFormatter {
    static func duration(_ duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: duration) ?? "--"
    }
    
    static func rate(_ rate: Double) -> String {
        return String(format: "%.02f€", rate)
    }
    
    static func date(_ date: Date) -> String {
        return date.formatted(date: .complete, time: .omitted)
    }
}

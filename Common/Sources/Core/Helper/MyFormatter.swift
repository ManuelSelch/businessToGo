
import Foundation

public struct MyFormatter {
    public static func duration(_ duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: duration) ?? "--"
    }
    
    public static func rate(_ rate: Double) -> String {
        return String(format: "%.02f€", rate)
    }
    
    public static func date(_ date: Date) -> String {
        return date.formatted(date: .numeric, time: .omitted)
    }
}

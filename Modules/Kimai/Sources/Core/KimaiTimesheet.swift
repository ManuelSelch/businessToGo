import Foundation
import OfflineSync

public struct KimaiTimesheet: TableProtocol, Hashable {
    public var id: Int
    
    public var activity: Int
    public var project: Int
    public var user: Int
    public var tags: [String]
    public var begin: String
    public var end: String?
    
    public var description: String?

    public var rate: Double
    public var exported: Bool
    public var billable: Bool
}

extension KimaiTimesheet {
    
    public static let new = KimaiTimesheet()
    
    public static let sample = Self(
        id: 1,
        
        activity: 1,
        project: 1,
        user: 1,
        tags: ["Tag"],
        begin: "",
        rate: 35,
        exported: false,
        billable: true
    )
    
    public init(){
        id = -1
        
        activity = 0
        project = 0
        user = 0
        tags = []
        begin = ""
        end = nil
        description = ""
        rate = 0
        exported = false
        billable = true
    }
    
    
    public func getBeginDate() -> Date? {
        return getDate(begin)
    }
    
    public func getEndDate() -> Date? {
        if let end = end {
            return getDate(end)
        } else {
            return nil
        }
        
    }
    
    private func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
    
    public func calculateDuration() -> TimeInterval? {
        // Convert beginDate and endDate strings to Date objects
        var endDate = Date.now
        if let end = end
        {
            endDate = getDate(end) ?? Date.now
        }
        
        guard let beginDate = getDate(begin)
        else {
            return nil
        }
        
        // Calculate time difference in seconds
        let timeEntryDuration = endDate.timeIntervalSince(beginDate)
        return timeEntryDuration
    }
    
    public func getDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: calculateDuration() ?? 0) ?? "--"
    }
}

extension KimaiTimesheet {
    public static func totalHours(of timesheets: [KimaiTimesheet]) -> TimeInterval
    {
        var hours: TimeInterval = 0
        for timesheet in timesheets {
            hours += timesheet.calculateDuration() ?? 0
        }
        return hours
    }
    
    public static func totalRate(of timesheets: [KimaiTimesheet]) -> Double
    {
        var rate: Double = 0
        for timesheet in timesheets {
            rate += timesheet.rate
        }
        return rate
    }
    
    public static func lastEntryDate(of timesheets: [KimaiTimesheet]) -> Date? {
        var date: Date? = nil
        
        for timesheet in timesheets {
            if let currentDate = date,
               let timesheetDate = timesheet.getBeginDate()
            {
                if(timesheetDate > currentDate){
                    date = timesheetDate
                }
            } else {
                date = timesheet.getBeginDate()
            }
        }
        
        return date
    }
}


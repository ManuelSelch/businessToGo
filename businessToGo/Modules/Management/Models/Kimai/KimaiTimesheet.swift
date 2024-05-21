import Foundation
import OfflineSync

struct KimaiTimesheet: TableProtocol, Hashable {
    var activity: Int
    var project: Int
    var user: Int
    var tags: [String]
    var id: Int
    var begin: String
    var end: String?
    
    var description: String?

    var rate: Double
    var exported: Bool
    var billable: Bool
}

extension KimaiTimesheet {
    
    static let new = KimaiTimesheet()
    static let samples: [KimaiTimesheet] = [
        .new, .new, .new
    ]
    
    init(){
        activity = 0
        project = 0
        user = 0
        tags = []
        id = -1
        begin = ""
        end = nil
        description = ""
        rate = 0
        exported = false
        billable = true
    }
    
    
    func getBeginDate() -> Date? {
        return getDate(begin)
    }
    
    func getEndDate() -> Date? {
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
    
    func calculateDuration() -> TimeInterval? {
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
    
    func getDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: calculateDuration() ?? 0) ?? "--"
    }
}

extension KimaiTimesheet {
    static func totalHours(of timesheets: [KimaiTimesheet]) -> TimeInterval
    {
        var hours: TimeInterval = 0
        for timesheet in timesheets {
            hours += timesheet.calculateDuration() ?? 0
        }
        return hours
    }
    
    static func totalRate(of timesheets: [KimaiTimesheet]) -> Double
    {
        var rate: Double = 0
        for timesheet in timesheets {
            rate += timesheet.rate
        }
        return rate
    }
    
    static func lastEntryDate(of timesheets: [KimaiTimesheet]) -> Date? {
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


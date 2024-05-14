import Foundation
import OfflineSync

struct KimaiTimesheet: TableProtocol {
    var activity: Int
    var project: Int
    // var user: Int
    // var tags: [String]
    var id: Int
    var begin: String
    var end: String?
    // var duration: Int
    
    var description: String?
    /*
    var rate: Double
    var exported: Bool
    var billable: Bool
    */
    
    // var metaFields: [String : String]
    
    
    
}

extension KimaiTimesheet {
    
    static let new = KimaiTimesheet()
    
    init(){
        activity = 0
        project = 0
        // user = 0
        // tags = []
        id = -1
        begin = ""
        end = nil
        description = ""
        
        /*
        duration = 0
        description = ""
        rate = 0
        exported = false
        billable = false
        */
        // metaFields = [:]
    }
    
    
    func getDate(_ dateStr: String) -> Date? {
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
}



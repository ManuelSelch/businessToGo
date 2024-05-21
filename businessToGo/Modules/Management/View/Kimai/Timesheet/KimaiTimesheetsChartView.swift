import SwiftUI
import MyChart

struct KimaiTimesheetsChartView: View {
    let activities: [KimaiActivity]
    let timesheets: [KimaiTimesheet]
    
    var projectClicked: (_ id: Int) -> ()

    var body: some View {
        let activityTimes = calculateTimesheets()
        VStack {
            ChartPieView(activityTimes)
            ChartListView(activityTimes, projectClicked)
        }
            .background(Color.background)
    }
    
    func calculateTimesheets() -> [ChartItem] {
        var activityTimes: [ChartItem] = []
        
        for timesheet in timesheets {
            if  let activity = activities.first(where: { $0.id == timesheet.id }) {
                
                if let index = activityTimes.firstIndex(where: { $0.id == activity.id }),
                   let duration = timesheet.calculateDuration()
                {
                    activityTimes[index].value += duration
                }else {
                    activityTimes.append(ChartItem(id: activity.id, name: activity.name, value: 0))
                }
            }
        }
        
        return activityTimes
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
    
    
}


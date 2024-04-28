import SwiftUI
import Charts

struct ChartItem {
    var id: Int
    var value: Double
}

struct KimaiChartView: View {
    let projects: [KimaiProject]
    let timesheets: [KimaiTimesheet]
    
    let formatter: DateComponentsFormatter
    
    init(projects: [KimaiProject], timesheets: [KimaiTimesheet]) {
        self.projects = projects
        self.timesheets = timesheets
        
        formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
    }
    
    var body: some View {
        VStack {
            let projectTimes = calculateProjectTimes(timesheets)
            var projectTimesOrderes:  [ChartItem] {
                var t = projectTimes
                t.sort { $0.value > $1.value }
                return t
            }
            
            
            Chart(projectTimesOrderes, id: \.id) { item in
                let name = projects.first { $0.id == item.id }?.name ?? "\(item.id)"
                SectorMark(
                    angle: .value("Duration", item.value)
                )
                .foregroundStyle(by: .value("Project", name))
            
            }
            .padding()
            .frame(height: 200)
   
            List(projectTimesOrderes, id: \.id){ item in
                let name = projects.first { $0.id == item.id }?.name ?? "\(item.id)"
                let valueStr = formatter.string(from: item.value) ?? "--"
                HStack {
                    Text(name)
                    Spacer()
                    Text(valueStr)
                }
            }
             
        }
    }
    
    func calculateProjectTimes(_ timesheets: [KimaiTimesheet]) -> [ChartItem] {
        var projectTimes: [ChartItem] = []
        
        for timesheet in timesheets {
            if let duration = timesheet.calculateDuration() {
                if let index = projectTimes.firstIndex(where: { $0.id == timesheet.project }) {
                    projectTimes[index].value += duration
                } else {
                    projectTimes.append(ChartItem(id: timesheet.project, value: duration))
                }
            }
        }
        
        return projectTimes
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
    
    
}

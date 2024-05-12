import SwiftUI
import MyChart

struct KimaiTimesheetsChartView: View {
    let activities: [KimaiActivity]
    let timesheets: [KimaiTimesheet]
    
    var projectClicked: (_ id: Int) -> ()

    var body: some View {
        let activityTimes = calculateTimesheets()
        ChartView(activityTimes, projectClicked)
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

struct KimaiProjectsChartView: View {
    let projects: [KimaiProject]
    let timesheets: [KimaiTimesheet]
    
    var projectClicked: (_ id: Int) -> ()

    var body: some View {
        let projectTimes = calculateProjectTimes()
        ChartView(projectTimes, projectClicked)
            .background(Color.background)
    }
    
    func calculateProjectTimes() -> [ChartItem] {
        var projectTimes: [ChartItem] = []
        
        for project in projects {
            projectTimes.append(ChartItem(id: project.id, name: project.name, value: 0))
        }
        
        for timesheet in timesheets {
            if  let index = projectTimes.firstIndex(where: { $0.id == timesheet.project }),
                let duration = timesheet.calculateDuration() 
            {
                projectTimes[index].value += duration
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


struct KimaiCustomersChartView: View {
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    let timesheets: [KimaiTimesheet]
    
    var customerClicked: (_ id: Int) -> ()
    
    var body: some View {
        let customerTimes = calculateCustomersTimes()
        ChartView(customerTimes, customerClicked)
            .background(Color.background)
    }
    
    func calculateCustomersTimes() -> [ChartItem] {
        var customerTimes: [ChartItem] = []
        for customer in customers {
            customerTimes.append(ChartItem(id: customer.id, name: customer.name, value: 0))
        }
        
        for timesheet in timesheets {
            if  let project = projects.first(where: { $0.id == timesheet.project }),
                let customer = customers.first(where: { $0.id == project.customer }),
                let index = customerTimes.firstIndex(where: { $0.id == customer.id }),
                let duration = timesheet.calculateDuration()
            {
                customerTimes[index].value += duration
            }
        }
        
        return customerTimes
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
    
    
}

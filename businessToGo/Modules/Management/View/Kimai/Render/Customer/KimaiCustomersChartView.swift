import SwiftUI
import MyChart

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

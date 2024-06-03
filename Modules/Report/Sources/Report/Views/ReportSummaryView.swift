import SwiftUI

import ManagementDependencies

struct ReportSummaryView: View {
    let timesheets: [KimaiTimesheet]
    
    var totalTime: String {
        var time: TimeInterval = 0
        for timesheet in timesheets {
            time += timesheet.calculateDuration() ?? 0
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: time) ?? "--"
    }
    
    var totalRate: String {
        var rate: Double = 0
        for timesheet in timesheets {
            rate += timesheet.rate
        }
        return String(format: "%.02f€", rate)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Zeit")
                    .foregroundStyle(Color.textHeaderSecondary)
                Text(totalTime)
                    .font(.system(size: 20, weight: .heavy))
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Einnahmen")
                    .foregroundStyle(Color.textHeaderSecondary)
                Text("\(totalRate)")
                    .font(.system(size: 20, weight: .heavy))
            }
            
        }
        .padding()
    }
}

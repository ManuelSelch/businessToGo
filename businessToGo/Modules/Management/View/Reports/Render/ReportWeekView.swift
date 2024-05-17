import SwiftUI
import Charts

struct WeekReportView: View {
    var days: [DayReport]
    
    var body: some View {
        
        VStack {
            Chart {
                ForEach(days) { weekDay in
                    BarMark(
                        x: .value("Name", weekDay.name),
                        y: .value("Number", weekDay.time/3600)
                    )
                    .foregroundStyle(Color.theme)
                    .cornerRadius(7)
                }
                
               
            }
        }
        .padding()
    }
}

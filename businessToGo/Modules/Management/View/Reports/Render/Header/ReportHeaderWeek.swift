import SwiftUI

struct ReportHeaderWeek: View {
    @Binding var selectedDate: Date
    let firstDay: Date
    
    var data: [WeekDay] {
        [
            WeekDay(name: "Mo", date: firstDay),
            WeekDay(name: "Di", date: firstDay.addDays(1)),
            WeekDay(name: "Mi", date: firstDay.addDays(2)),
            WeekDay(name: "Do", date: firstDay.addDays(3)),
            WeekDay(name: "Fr", date: firstDay.addDays(4)),
            WeekDay(name: "Sa", date: firstDay.addDays(5)),
            WeekDay(name: "So", date: firstDay.addDays(6))
        ]
    }

    
    var body: some View {
        HStack {
            ForEach(data) { weekDay in
                ReportHeaderDay(day: weekDay, selected: $selectedDate)
            }
        }
        .frame(width: .infinity)
    }
}

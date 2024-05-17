import SwiftUI

struct ReportHeaderDay: View {
    var day: WeekDay
    @Binding var selected: Date
    
    var body: some View {
        Button(action: {
            selected = day.date
        }) {
            VStack {
                Text("\(day.date.getDay() ?? 1)")
                    .font(.system(size: 15, weight: .heavy))
                Text(day.name)
                    .font(.system(size: 15, weight: .light))
            }
            .padding(5)
            .background(day.date == selected ? Color.contrast : Color.darkGray)
            .foregroundColor(day.date == selected ? Color.background : Color.contrast)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        
    }
}

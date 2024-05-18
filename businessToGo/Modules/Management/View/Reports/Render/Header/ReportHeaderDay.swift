import SwiftUI

struct ReportHeaderDay: View {
    var day: WeekDay
    @Binding var selected: Date
    
    var color: Color {
        if(day.date == selected){
            return Color.background
        } else {
            if(day.date == Date.today){
                return Color.theme
            } else {
                return Color.contrast
            }
        }
    }
    
    var background: Color {
        if(day.date == selected){
            if(day.date == Date.today){
                return Color.theme
            } else {
                return Color.contrast
            }
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        Button(action: {
            selected = day.date
        }) {
            VStack {
                Text("\(day.date.getDay() ?? 1)")
                    .font(.system(size: 15, weight: .heavy))
                Text(day.name)
                    .font(.system(size: 10, weight: .light))
            }
            .padding([.vertical], 5)
            .padding([.horizontal], 10)
            .background(background)
            .foregroundColor(color)
            
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        
    }
}

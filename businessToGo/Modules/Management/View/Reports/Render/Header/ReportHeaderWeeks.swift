import SwiftUI

struct ReportHeaderWeeks: View {
    @Binding var selectedDate: Date
    let firstDay: Date // first day of week
    let lastDay: Date // last day of month
    
    init(selectedDate: Binding<Date>) {
        firstDay = Date.now.startOfWeek()
        lastDay = firstDay.endOfMonth()
        
        _selectedDate = selectedDate
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<3) { i in
                        ReportHeaderWeek(selectedDate: $selectedDate, firstDay: firstDay.addDays(i*7))
                            .frame(width: geo.size.width, height: 100)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
        .frame(height: 100)
    }
}

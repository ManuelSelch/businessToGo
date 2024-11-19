import SwiftUI

import CommonCore

struct ReportHeaderWeeks: View {
    @Binding var selectedDate: Date
    var firstDay: Date {
        selectedDate.startOfWeek()
    }
    @State var scrolledID: Int? = 1
    @State var lastID: Int = 1
    
    @State var weeks: [Date] = [
        Date.today.startOfMonth().startOfWeek(),
        Date.today.startOfMonth().startOfWeek().addDays(+7),
        Date.today.startOfMonth().startOfWeek().addDays(+14),
        Date.today.startOfMonth().startOfWeek().addDays(+21)
    ]

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<weeks.count, id: \.self) { i in
                            ReportHeaderWeek(selectedDate: $selectedDate, firstDay: weeks[i])
                                .id(i)
                                .frame(width: geo.size.width, height: 100)
                        }
                    }
                    // .scrollTargetLayout()
                }
                // .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .onChange(of: scrolledID){ _ in
                    if let newID = scrolledID
                    {
                        withAnimation(.easeInOut) {
                            if(newID > lastID){
                                selectedDate = selectedDate.addDays(+7)
                            }else if(newID < lastID){
                                selectedDate = selectedDate.addDays(-7)
                            }
                        }
                        lastID = newID
                    }
                }
                .onChange(of: selectedDate) { _ in
                    scrolledID = (selectedDate.getWeekOfMonth() ?? 1) - 1
                    lastID = (selectedDate.getWeekOfMonth() ?? 1) - 1
                }
                // .scrollPosition(id: $scrolledID)
                
                
            }
            .frame(height: 100)
            
            HStack {
                Spacer()
                Text(selectedDate.formatted(date: .complete, time: .omitted))
                    .font(.system(size: 15))
                Spacer()
            }
        }
        .onAppear {
            scrolledID = (selectedDate.getWeekOfMonth() ?? 1) - 1
            lastID = (selectedDate.getWeekOfMonth() ?? 1) - 1
        }
    }
}


#Preview {
    return ReportHeaderWeeks(selectedDate: .constant(Date.today))
}


import SwiftUI
import Charts

struct WeekDay: Identifiable {
    var name: String
    var number: Int
    var id = UUID()
}

enum ReportDate: String, CaseIterable, Identifiable{
    case day = "Tag"
    case week = "Woche"
    case month = "Monat"
    case year = "Jahr"
    
    var id: Self { self }
}
struct ReportView: View {
    @State var selectedReportDate: ReportDate = .week
    
    
    var body: some View {
        VStack {
            HeaderView(selectedReportDate: $selectedReportDate)
            
            ScrollView {
                DayReport()
                WeekReport()
                ReportSessions()
            }
        }
        
    }
}



struct HeaderView: View {
    @Binding var selectedReportDate: ReportDate
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Report Date", selection: $selectedReportDate){
                ForEach(ReportDate.allCases) { option in
                    Text(option.rawValue)
                    
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .background(Color.darkGray)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .accentColor(Color.contrast)
            
            
            WeekPicker()
            
        }
        .padding()
        .background(Color.darkGray)
        .foregroundStyle(Color.contrast)
    }
}

struct WeekPicker: View {
    @State var selectedIndex = 0
    let firstDay: Int // first day of week
    let lastDay: Int // last day of month
    
    init() {
        let start = Calendar.weekStart(for: Date.now) ?? Date.now
        let calendarDateStart = Calendar.current.dateComponents([.day, .year, .month], from: start)
        firstDay = calendarDateStart.day ?? 1
        
        let end = Date().endOfMonth()
        let calendarDateEnd = Calendar.current.dateComponents([.day, .year, .month], from: end)
        lastDay = calendarDateEnd.day ?? 1
        
        selectedIndex = firstDay
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<3) { i in
                        WeekView(selectedIndex: $selectedIndex, firstDay: firstDay + i*7)
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

struct WeekView: View {
    @Binding var selectedIndex: Int
    let firstDay: Int
    
    var data: [WeekDay] {
        [
            WeekDay(name: "Mo", number: firstDay),
            WeekDay(name: "Di", number: firstDay+1),
            WeekDay(name: "Mi", number: firstDay+2),
            WeekDay(name: "Do", number: firstDay+3),
            WeekDay(name: "Fr", number: firstDay+4),
            WeekDay(name: "Sa", number: firstDay+5),
            WeekDay(name: "So", number: firstDay+6)
        ]
    }

    
    var body: some View {
        HStack {
            ForEach(data) { weekDay in
                DayView(day: weekDay, selected: $selectedIndex)
            }
        }
        .frame(width: .infinity)
    }
}

struct DayView: View {
    var day: WeekDay
    @Binding var selected: Int
    
    var body: some View {
        Button(action: {
            selected = day.number
        }) {
            VStack {
                Text("\(day.number)")
                    .font(.system(size: 15, weight: .heavy))
                Text(day.name)
                    .font(.system(size: 15, weight: .light))
            }
            .padding(5)
            .background(day.number == selected ? Color.contrast : Color.darkGray)
            .foregroundColor(day.number == selected ? Color.background : Color.contrast)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        
    }
}

struct ReportSessions: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sessions")
                .font(.system(size: 25, weight: .heavy))
            
            HStack {
                Text("WEDNESDAY, MAY 15")
                Spacer()
                Text("0:18")
            }
            .font(.system(size: 15))
            .foregroundStyle(.textHeaderSecondary)
            
            ReportSession()
            ReportSession()
            ReportSession()
            ReportSession()
        }
        .padding()
    }
}

struct ReportSession: View {
    var body: some View {
        HStack {
            VStack {
                Text("19:08")
                    .font(.system(size: 12))
                
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.contrast)
                    .font(.system(size: 12))
                    .frame(width: 30, height: 10)
                    .rotationEffect(.degrees(90))
        
                
                Text("19:22")
                    .font(.system(size: 12))
            }
            
            Rectangle()
               .frame(width: 2, height: 50)
               .foregroundColor(Color.theme)
            
            Image(systemName: "icloud.and.arrow.up")
            
            VStack(alignment: .leading) {
                Text("T3")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(Color.theme)
                
                Text("No notes")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textHeaderSecondary)
                    .italic()
            }
            
            Spacer()
            
            Text("0:13")
                .font(.system(size: 12, weight: .heavy))
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textHeaderSecondary)
        }
        .padding(5)
        .background(Color.darkGray)
        .foregroundStyle(Color.contrast)
        .cornerRadius(8)
    }
}

struct DayReport: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Zeit")
                    .foregroundStyle(Color.textHeaderSecondary)
                Text("0:18")
                    .font(.system(size: 20, weight: .heavy))
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Einnahmen")
                    .foregroundStyle(Color.textHeaderSecondary)
                Text("0,00€")
                    .font(.system(size: 20, weight: .heavy))
            }
            
        }
        .padding()
    }
}

struct WeekReport: View {
    var data: [WeekDay] = [
        .init(name: "Mo", number: 0),
        .init(name: "Di", number: 0),
        .init(name: "Mi", number: 4),
        .init(name: "Do", number: 0),
        .init(name: "Fr", number: 6),
        .init(name: "Sa", number: 0),
        .init(name: "So", number: 0)
    ]
    
    var body: some View {
        
        VStack {
            Chart {
                ForEach(data) { weekDay in
                    BarMark(
                        x: .value("Name", weekDay.name),
                        y: .value("Number", weekDay.number)
                    )
                    .foregroundStyle(Color.theme)
                    .cornerRadius(7)
                }
                
               
            }
        }
        .padding()
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Calendar {
    static func weekStart(for date: Date = Date()) -> Date? {
        guard let weekInterval = Self.autoupdatingCurrent.dateInterval(
                of: .weekOfYear, for: date) else { return nil }

        return weekInterval.start
    }
}

#Preview {
    ReportView()
}

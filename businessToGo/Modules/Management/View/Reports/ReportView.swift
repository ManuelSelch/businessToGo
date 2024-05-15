
import SwiftUI
import Charts

struct ToyShape: Identifiable {
    var type: String
    var count: Double
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
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<10) { i in
                        WeekView()
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
    var body: some View {
        HStack {
            DayView()
            DayView(selected: true)
            DayView()
            DayView()
            DayView()
            DayView()
            DayView()
        }
        .frame(width: .infinity)
    }
}

struct DayView: View {
    var selected: Bool = false
    
    var body: some View {
        VStack {
            Text("20")
                .font(.system(size: 15, weight: .heavy))
            Text("Mon")
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(Color.textHeaderSecondary)
        }
        .padding(5)
        .background(selected ? Color.theme : Color.darkGray)
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
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
                
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.contrast)
                    .frame(width: 30, height: 20) // Adjust size as needed
                    .rotationEffect(.degrees(90)) // Rotate the image 90 degrees clockwise
        
                
                Text("19:22")
            }
            
            Rectangle()
               .frame(width: 2, height: 50)
               .foregroundColor(Color.theme)
            
            VStack(alignment: .leading) {
                Text("T3")
                    .foregroundStyle(Color.theme)
                    .fontWeight(.heavy)
                
                Text("No notes")
                    .foregroundStyle(Color.textHeaderSecondary)
                    .italic()
            }
            
            Spacer()
            
            Text("0:13")
                .fontWeight(.heavy)
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textHeaderSecondary)
        }
        .padding()
        .background(Color.darkGray)
        .foregroundStyle(Color.contrast)
        .cornerRadius(8)
    }
}

struct DayReport: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Time Tracked")
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
    var data: [ToyShape] = [
        .init(type: "Mo", count: 0),
        .init(type: "Di", count: 0),
        .init(type: "Mi", count: 4),
        .init(type: "Do", count: 0),
        .init(type: "Fr", count: 0),
        .init(type: "Sa", count: 8),
        .init(type: "So", count: 0)
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data) { shape in
                    BarMark(
                        x: .value("Shape Type", shape.type),
                        y: .value("Total Count", shape.count)
                    )
                    .foregroundStyle(Color.theme)
                    .cornerRadius(7)
                }
                
               
            }
        }
        .padding()
    }
}

#Preview {
    ReportView()
}

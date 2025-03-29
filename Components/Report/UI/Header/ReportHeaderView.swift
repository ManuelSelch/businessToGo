import SwiftUI
import Redux

import KimaiCore

struct ReportHeaderView: View {
    @Binding var selectedReportType: ReportType
    @Binding var selectedDate: Date
    @Binding var selectedProject: Int?
    
    var projects: [KimaiProject]
    
    var calendarTapped: () -> ()
    var filterTapped: () -> ()
    var playTapped: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: filterTapped) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                
                let reportTypes = ReportType.allCases.filter({$0 != .day})
                Picker("Report Date", selection: $selectedReportType){
                    ForEach(reportTypes) { option in
                        Text(option.rawValue)
                        
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accentColor(Color.contrast)
                
                Button(action: playTapped){
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme)
                }
            }
            .font(.system(size: 20))
            .foregroundStyle(Color.theme)
            
            switch(selectedReportType){
            case .day:
                ReportHeaderWeeks(selectedDate: $selectedDate)
            case .week:
                EmptyView()
            case .month:
                HStack {
                    Image(systemName: "arrow.left")
                    Spacer()
                    Text("Dez. 2024")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
            case .year: EmptyView()
            }
            
            
        }
        .padding()
        .foregroundStyle(Color.contrast)
    }
}

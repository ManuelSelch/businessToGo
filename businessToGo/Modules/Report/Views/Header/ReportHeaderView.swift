import SwiftUI
import Redux

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
                Button(action: {
                    calendarTapped()
                }){
                    Image(systemName: "calendar")
                        
                }
                
                Button(action: {
                    filterTapped()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                
                Picker("Report Date", selection: $selectedReportType){
                    ForEach(ReportType.allCases) { option in
                        Text(option.rawValue)
                        
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .background(Color.themeGray)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accentColor(Color.contrast)
                
                Button(action: {
                    playTapped()
                }){
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme)
                }
            }
            .font(.system(size: 20))
            .foregroundStyle(Color.theme)
            
            switch(selectedReportType){
            case .day: ReportHeaderWeeks(selectedDate: $selectedDate)
            default: EmptyView()
            }
            
            
        }
        .padding()
        .background(Color.themeGray)
        .foregroundStyle(Color.contrast)
    }
}

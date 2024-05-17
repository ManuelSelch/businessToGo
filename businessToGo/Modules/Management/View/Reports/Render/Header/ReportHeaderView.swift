import SwiftUI

struct ReportHeaderView: View {
    @Binding var selectedReportType: ReportType
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("Report Date", selection: $selectedReportType){
                    ForEach(ReportType.allCases) { option in
                        Text(option.rawValue)
                        
                    }
                }
                .frame(height: 15)
                .pickerStyle(.segmented)
                .labelsHidden()
                .background(Color.darkGray)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accentColor(Color.contrast)
                
                
                Image(systemName: "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme)
            }
            
            switch(selectedReportType){
            case .day: ReportHeaderWeeks(selectedDate: $selectedDate)
            default: EmptyView()
            }
            
            
        }
        .padding()
        .background(Color.darkGray)
        .foregroundStyle(Color.contrast)
    }
}

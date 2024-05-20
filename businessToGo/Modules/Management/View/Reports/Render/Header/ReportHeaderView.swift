import SwiftUI

struct ReportHeaderView: View {
    @Binding var selectedReportType: ReportType
    @Binding var selectedDate: Date
    @Binding var isCalendarPicker: Bool
    @Binding var selectedProject: Int?
    
    var projects: [KimaiProject]
    
    var onEdit: (KimaiTimesheet) -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    isCalendarPicker = true
                }){
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme)
                }
                
                Picker("Report Date", selection: $selectedReportType){
                    ForEach(ReportType.allCases) { option in
                        Text(option.rawValue)
                        
                    }
                }
                .frame(height: 20)
                .pickerStyle(.segmented)
                .labelsHidden()
                .background(Color.themeGray)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accentColor(Color.contrast)
                
                Button(action: {
                    onEdit(KimaiTimesheet.new)
                }){
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme)
                }
            }
            
            switch(selectedReportType){
            case .day: ReportHeaderWeeks(selectedDate: $selectedDate)
            default: EmptyView()
            }
            
            Picker("Project", selection: $selectedProject){
                Text("Alle Projekte")
                    .tag(nil as Int?)
                
                ForEach(projects) { project in
                    Text(project.name)
                        .tag(project.id as Int?)
                }
            }
            
            
        }
        .padding()
        .background(Color.themeGray)
        .foregroundStyle(Color.contrast)
    }
}

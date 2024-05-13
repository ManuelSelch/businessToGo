import SwiftUI

struct ManagementHeaderView: View {
    @Binding var timesheetView: KimaiTimesheet?
    let route: ManagementRoute?
    
    var projectId: Int? {
        switch(route){
        case .kimai(.project(let id)): return id
            default: return nil
        }
    }
    
    var projects: [KimaiProject]
    
    let onChart: () -> Void
    let onProjectClicked: (Int) -> Void
    let onSync: () -> ()
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                onSync()
            }){
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme)
            }
            
            if(route == nil){
                Button(action: {
                    onChart()
                }){
                    Image(systemName: "chart.bar.xaxis.ascending")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            }
            
            if let id = projectId {
                Button(action: {
                    onProjectClicked(id)
                }){
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            }
            
            
            Button(action: {
                switch(route){
                case .kimai(.customer(let customer)):
                    let project = projects.first { $0.customer ==  customer}
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = project?.id ?? 0
                    timesheetView = timesheet
                case .kimai(.project(let project)):
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = project
                    timesheetView = timesheet
                default:
                    timesheetView = KimaiTimesheet.new
                }
                
            }){
                Image(systemName: "play.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme)
            }
            
        }
    }
}

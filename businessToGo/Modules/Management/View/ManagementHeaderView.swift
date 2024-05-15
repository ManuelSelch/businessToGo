import SwiftUI

struct ManagementHeaderView: View {
    @Binding var timesheetView: KimaiTimesheet?
    @Binding var selectedTeam: Int

    
    let route: ManagementRoute?
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]
    
    let onChart: () -> Void
    let onProjectClicked: (Int) -> Void
    let onSync: () -> ()

    
    var body: some View {
        HStack {
            
            if(route == nil) {
                
                Picker("", selection: $selectedTeam) {
                    Text("Alle Teams")
                        .tag(-1)
                    ForEach(teams, id: \.id) { team in
                        Text(team.name)
                            .tag(team.id)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
                .clipped()
                
            }
            
            
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
            
            switch(route){
            case .kimai(.project(let id)):
                Button(action: {
                    onProjectClicked(id)
                }){
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            default: EmptyView()
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

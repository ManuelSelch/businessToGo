import SwiftUI

struct ManagementHeaderView: View {
    @Binding var timesheetView: KimaiTimesheet?
    @Binding var selectedTeam: Int

    
    let route: ManagementRoute?
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]
    
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
             
            Button(action: {
                switch(route){
                case .kimai(.customer(let customer)):
                    let project = projects.first { $0.customer ==  customer}
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = project?.id ?? 0
                    timesheetView = timesheet
                case .taiga(.project(let integration)):
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = integration.id
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

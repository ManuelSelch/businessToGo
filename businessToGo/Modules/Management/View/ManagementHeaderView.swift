import SwiftUI

struct ManagementHeaderView: View {
    @Binding var selectedTeam: Int?

    let route: ManagementRoute?
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]
    
    let router: (RouteAction<ManagementRoute>) -> ()
    let onSync: () -> ()

    
    var body: some View {
        HStack {
            
            if(route == nil) {
                
                Picker("", selection: $selectedTeam) {
                    Text("Alle Teams")
                        .tag(nil as Int?)
                    ForEach(teams, id: \.id) { team in
                        Text(team.name)
                            .tag(team.id as Int?)
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
                case .kimai(.projects(for: let customer)):
                    let project = projects.first { $0.customer ==  customer}
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = project?.id ?? 0
                    router(.presentSheet(.kimai(.timesheet(timesheet))))
                case .taiga(.project(let integration)):
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = integration.id
                    router(.presentSheet(.kimai(.timesheet(timesheet))))
                default:
                    router(.presentSheet(.kimai(.timesheet(KimaiTimesheet.new))))
                }
                
            }){
                Image(systemName: "play.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme)
            }
            
        }
    }
}

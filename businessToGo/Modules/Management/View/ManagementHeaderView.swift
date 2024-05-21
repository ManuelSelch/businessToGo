import SwiftUI
import Redux

struct ManagementHeaderView: View {
    @Binding var selectedTeam: Int?

    let route: ManagementRoute?
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]
    
    let router: (RouteModule<ManagementRoute>.Action) -> ()
    let onSync: () -> ()

    
    var body: some View {
        HStack {
            
            switch(route){
            case nil:
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
                
            case .taiga(.project(let integration)):
                Button(action: {
                    router(.push(.kimai(.projectDetails(integration.id))))
                }){
                    Image(systemName: "chart.bar.xaxis.ascending")
                }
            default: EmptyView()
            }
            
            
            
            
            Button(action: {
                onSync()
            }){
                Image(systemName: "arrow.triangle.2.circlepath")
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
            }
            
        }
        .font(.system(size: 15))
        .foregroundColor(Color.theme)
    }
}

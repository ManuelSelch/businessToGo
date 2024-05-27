import SwiftUI
import Redux

struct ManagementHeaderView: View {
    @Binding var selectedTeam: Int?

    let route: ManagementScreen.State?
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]

    let syncTapped: () -> ()
    let projectTapped: (Integration) -> ()
    let playTapped: (KimaiTimesheet) -> ()

    
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
            
         
            case let .taiga(.project(state)):
                Button(action: {
                    projectTapped(state.integration)
                }){
                    Image(systemName: "chart.bar.xaxis.ascending")
                }
                 
                
            default: EmptyView()
            }
            
            
            
            
            Button(action: {
                syncTapped()
            }){
                Image(systemName: "arrow.triangle.2.circlepath")
            }
             
            Button(action: {
                switch(route){
                case let .kimai(.projectsList(state)):
                    let project = projects.first { $0.customer == state.customer}
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = project?.id ?? 0
                    playTapped(timesheet)
                // TODO: check taiga route
                /*
                case .taiga(.project(let integration)):
                    var timesheet = KimaiTimesheet.new
                    timesheet.project = integration.id
                    playTapped(timesheet)
                 */
                default:
                    playTapped(KimaiTimesheet.new)
                }
                
            }){
                Image(systemName: "play.fill")
            }
            
        }
        .font(.system(size: 15))
        .foregroundColor(Color.theme)
    }
}

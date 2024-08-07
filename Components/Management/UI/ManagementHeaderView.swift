import SwiftUI

import CommonUI
import KimaiCore
import IntegrationCore

struct ManagementHeaderView: View {
    @Binding var selectedTeam: Int?

    let route: ManagementContainer.Route
    
    var projects: [KimaiProject]
    var teams: [KimaiTeam]

    let syncTapped: () -> ()
    let projectTapped: (Integration) -> ()
    let playTapped: (KimaiTimesheet) -> ()
    
    init(selectedTeam: Binding<Int?>, route: ManagementContainer.Route, projects: [KimaiProject], teams: [KimaiTeam], syncTapped: @escaping () -> Void, projectTapped: @escaping (Integration) -> Void, playTapped: @escaping (KimaiTimesheet) -> Void) {
        self._selectedTeam = selectedTeam
        self.route = route
        self.projects = projects
        self.teams = teams
        self.syncTapped = syncTapped
        self.projectTapped = projectTapped
        self.playTapped = playTapped
    }
    
    var body: some View {
        HStack {
            
            switch(route){
            case .kimai(.customersList):
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
            
         
            case let .taiga(.project(kimai, taiga)):
                Button(action: {
                    projectTapped(Integration(kimai, taiga))
                }){
                    Image(systemName: "chart.bar.xaxis.ascending")
                }
                 
                
            default: EmptyView()
            }
            
            switch(route) {
            case .assistant: EmptyView()
            default:
                Button(action: {
                    syncTapped()
                }){
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                
                Button(action: {
                    switch(route){
                    case let .kimai(.projectsList(customer)):
                        let project = projects.first { $0.customer == customer}
                        var timesheet = KimaiTimesheet.new
                        timesheet.project = project?.id ?? 0
                        playTapped(timesheet)
   
                    case let .kimai(.projectDetail(projectId)):
                        let project = projects.first { $0.id == projectId}
                        var timesheet = KimaiTimesheet.new
                        timesheet.project = project?.id ?? 0
                        playTapped(timesheet)
                        
                    default:
                        playTapped(KimaiTimesheet.new)
                    }
                    
                }){
                    Image(systemName: "play.fill")
                }
            }
      
            
        }
        .font(.system(size: 15))
        .foregroundColor(Color.theme)
    }
}

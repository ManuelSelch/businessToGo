import SwiftUI

import CommonUI
import KimaiCore
import IntegrationCore

struct ManagementHeaderView: View {
    @Binding var selectedTeam: Int?

    let route: ManagementComponent.Route

    var projects: [KimaiProject]
    var teams: [KimaiTeam]
    var isSyncing: Bool

    let syncTapped: () -> ()
    let projectTapped: (Integration) -> ()
    let playTapped: (KimaiTimesheet) -> ()
    let settingsTapped: () -> ()
    
    init(
        selectedTeam: Binding<Int?>, route: ManagementComponent.Route,
        projects: [KimaiProject], teams: [KimaiTeam],
        isSyncing: Bool,
        
        syncTapped: @escaping () -> Void,
        projectTapped: @escaping (Integration) -> Void,
        playTapped: @escaping (KimaiTimesheet) -> Void,
        settingsTapped: @escaping () -> ()
    ) {
        self._selectedTeam = selectedTeam
        self.route = route
        self.projects = projects
        self.teams = teams
        self.isSyncing = isSyncing
        
        self.syncTapped = syncTapped
        self.projectTapped = projectTapped
        self.playTapped = playTapped
        self.settingsTapped = settingsTapped
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
            
                
            default: EmptyView()
            }
            
            switch(route) {
            case .assistant, .kimai(.activitySheet), .kimai(.customerSheet), .kimai(.projectSheet), .kimai(.timesheetSheet):
                EmptyView()
            default:
                if(isSyncing) {
                    ProgressView()
                } else {
                    Button(action: syncTapped){
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
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
                
                Button(action: settingsTapped) {
                    Image(systemName: "gear")
                }
            }
      
            
        }
        .font(.system(size: 15))
        .foregroundColor(Color.theme)
    }
}

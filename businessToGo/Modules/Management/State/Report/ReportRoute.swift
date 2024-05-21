import Foundation
import SwiftUI
import Redux

enum ReportRoute: Codable, Equatable, Hashable, Identifiable {
    case reports
    case timesheet(KimaiTimesheet)
    case calendar
    
    case filter
    case filterProjects
    
    var id: Self {self}
}


extension ReportRoute {
    @ViewBuilder func createView(_ store: StoreOf<ManagementModule>) -> some View {
        switch self {
        case .reports:
            ReportsView(
                timesheets: store.state.kimai.timesheets,
                projects: store.state.kimai.projects,
                activities: store.state.kimai.activities,
                timesheetTracks: store.state.kimai.timesheetTracks,
                
                selectedProject: Binding(get: { store.state.report.selectedProject }, set: { store.send(.report(.selectProject($0))) }),
                selectedDate: Binding(get: { store.state.report.selectedDate }, set: { store.send(.report(.selectDate($0))) }),
                
                router: { store.send(.report(.route($0))) },
                onDelete: { store.send(.kimai(.timesheets(.delete($0)))) }
            )
        case .timesheet(let timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.kimai.customers,
                projects: store.state.kimai.projects,
                activities: store.state.kimai.activities,
                onSave: {
                    if($0.id == KimaiTimesheet.new.id){
                        store.send(.kimai(.timesheets(.create($0))))
                    } else {
                        store.send(.kimai(.timesheets(.update($0))))
                    }
                }
            )
        case .calendar:
            YearMonthPickerView(
                selectedDate: Binding(get: { store.state.report.selectedDate }, set: { store.send(.report(.selectDate($0))) })
            )
        
        case .filter:
            ReportFilterView(
                customers: store.state.kimai.customers,
                projects: store.state.kimai.projects,
                selectedProject: Binding(get: { store.state.report.selectedProject }, set: { store.send(.report(.selectProject($0))) }),
                router: { store.send(.report(.route($0))) }
            )
            
        case .filterProjects:
            ReportFilterProjectsView(
                customers: store.state.kimai.customers,
                projects: store.state.kimai.projects,
                selectedProject: Binding(get: { store.state.report.selectedProject }, set: { store.send(.report(.selectProject($0))) }),
                router: { store.send(.report(.route($0))) }
            )
        }
    }
}

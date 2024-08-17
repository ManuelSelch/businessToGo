import Redux

extension ReportComponent {
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case .calendarTapped:
            state.router.presentSheet(.report(.calendar))
        case .filterTapped:
            state.router.presentSheet(.report(.filter))
        case .filterProjectsTapped:
            state.router.push(.report(.filterProjects))
        case let .filterProjectTapped(project):
            state.report.selectedProject = project
            state.router.dismiss()
        case .playTapped:
            state.router.presentSheet(.management(.kimai(.timesheetSheet(.new))))
        case let .editTimesheetTapped(timesheet):
            state.router.presentSheet(.management(.kimai(.timesheetSheet(timesheet))))
        }
        return .none
    }
}

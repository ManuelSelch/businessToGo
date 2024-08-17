import Redux

extension ManagementComponent {
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case let .playTapped(timesheet):
            state.router.presentSheet(.management(.kimai(.timesheetSheet(timesheet))))
        case .settingsTapped:
            state.router.presentSheet(.settings(.settings))
        }
        return .none
    }
}

import Redux

extension ManagementContainer {
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case let .playTapped(timesheet):
            state.router.presentSheet(.management(.kimai(.timesheetSheet(timesheet))))
            
        case let .kimai(action):
            return KimaiContainer.reduce(&state, action)
        }
        return .none
    }
}

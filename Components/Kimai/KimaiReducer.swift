import Redux

extension KimaiComponent {
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action){            
        case let .customerTapped(customer):
            state.router.push(.management(.kimai(.projectsList(for: customer))))
        case let .customerEditTapped(customer):
            state.router.presentSheet(.management(.kimai(.customerSheet(customer))))
        case let .customerSaveTapped(customer):
            state.router.dismiss()
            return .send(.kimai(.customer(.save(customer))))
            
        case let .projectTapped(project):
            state.router.push(.management(.kimai(.projectDetail(project))))
        case let .projectEditTapped(project):
            state.router.presentSheet(.management(.kimai(.projectSheet(project))))
        case let .projectSaveTapped(project):
            state.router.dismiss()
            return .send(.kimai(.project(.save(project))))
            
        case let .activityEditTapped(activity):
            state.router.presentSheet(.management(.kimai(.activitySheet(activity))))
        case let .activitySaveTapped(activity):
            state.router.dismiss()
            return .send(.kimai(.activity(.save(activity))))
            
        case let .timesheetEditTapped(timesheet):
            state.router.presentSheet(.management(.kimai(.timesheetSheet(timesheet))))
        case let .timesheetSaveTapped(timesheet):
            state.router.dismiss()
            return .send(.kimai(.timesheet(.save(timesheet))))
        
        }
        return .none
    }
}

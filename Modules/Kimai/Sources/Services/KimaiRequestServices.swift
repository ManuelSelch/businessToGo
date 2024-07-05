import Dependencies
import OfflineSync
import KimaiCore

var tables = KimaiTable()

struct CustomersKey: DependencyKey {
    static var liveValue: RequestService<KimaiCustomer, KimaiAPI> = .live(
        table: tables.customers,
        fetchMethod: .simple(.getCustomers),
        insertMethod: KimaiAPI.insertCustomer,
        updateMethod: KimaiAPI.updateCustomer,
        deleteMethod: nil
    )
    
    static var mockValue: RequestService<KimaiCustomer, KimaiAPI> = .mock(
        table: tables.customers,
        fetchMethod: .simple(.getCustomers),
        insertMethod: KimaiAPI.insertCustomer,
        updateMethod: KimaiAPI.updateCustomer,
        deleteMethod: nil
    )
}

struct ProjectsKey: DependencyKey {
    static var liveValue: RequestService<KimaiProject, KimaiAPI> = .live(
        table: tables.projects,
        fetchMethod: .simple(.getProjects),
        insertMethod: KimaiAPI.insertProject,
        updateMethod: KimaiAPI.updateProject,
        deleteMethod: nil
    )
    
    static var mockValue: RequestService<KimaiProject, KimaiAPI> = .mock(
        table: tables.projects,
        fetchMethod: .simple(.getProjects),
        insertMethod: KimaiAPI.insertProject,
        updateMethod: KimaiAPI.updateProject,
        deleteMethod: nil
    )
}

struct TimesheetsKey: DependencyKey {
    static var liveValue: RequestService<KimaiTimesheet, KimaiAPI> = .live(
        table: tables.timesheets,
        fetchMethod: .page(KimaiAPI.getTimesheets),
        insertMethod: KimaiAPI.insertTimesheet,
        updateMethod: KimaiAPI.updateTimesheet,
        deleteMethod: KimaiAPI.deleteTimesheet
    )
    
    static var mockValue: RequestService<KimaiTimesheet, KimaiAPI> = .mock(
        table: tables.timesheets,
        fetchMethod: .page(KimaiAPI.getTimesheets),
        insertMethod: KimaiAPI.insertTimesheet,
        updateMethod: KimaiAPI.updateTimesheet,
        deleteMethod: KimaiAPI.deleteTimesheet
    )
}

struct ActivitiesKey: DependencyKey {
    static var liveValue: RequestService<KimaiActivity, KimaiAPI> = .live(
        table: tables.activities,
        fetchMethod: .simple(.getActivities)
    )
    
    static var mockValue: RequestService<KimaiActivity, KimaiAPI> = .mock(
        table: tables.activities,
        fetchMethod: .simple(.getActivities)
    )
}

struct TeamsKey: DependencyKey {
    static var liveValue: RequestService<KimaiTeam, KimaiAPI> = .live(
        table: tables.teams,
        fetchMethod: .simple(.getTeams)
    )
    
    static var mockValue: RequestService<KimaiTeam, KimaiAPI> = .mock(
        table: tables.teams,
        fetchMethod: .simple(.getTeams)
    )
}

struct UsersKey: DependencyKey {
    static var liveValue: RequestService<KimaiUser, KimaiAPI> = .live(
        table: tables.users,
        fetchMethod: .simple(.getUsers)
    )
    
    static var mockValue: RequestService<KimaiUser, KimaiAPI> = .mock(
        table: tables.users,
        fetchMethod: .simple(.getUsers)
    )
}

extension DependencyValues {
    var customers: RequestService<KimaiCustomer, KimaiAPI> {
        get { Self[CustomersKey.self] }
        set { Self[CustomersKey.self] = newValue }
    }
    
    var projects: RequestService<KimaiProject, KimaiAPI> {
        get { Self[ProjectsKey.self] }
        set { Self[ProjectsKey.self] = newValue }
    }
    
    var timesheets: RequestService<KimaiTimesheet, KimaiAPI> {
        get { Self[TimesheetsKey.self] }
        set { Self[TimesheetsKey.self] = newValue }
    }
    
    var activities: RequestService<KimaiActivity, KimaiAPI> {
        get { Self[ActivitiesKey.self] }
        set { Self[ActivitiesKey.self] = newValue }
    }
    
    var teams: RequestService<KimaiTeam, KimaiAPI> {
        get { Self[TeamsKey.self] }
        set { Self[TeamsKey.self] = newValue }
    }
    
    var users: RequestService<KimaiUser, KimaiAPI> {
        get { Self[UsersKey.self] }
        set { Self[UsersKey.self] = newValue }
    }
}

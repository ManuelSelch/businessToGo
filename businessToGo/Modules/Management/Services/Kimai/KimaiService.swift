import Foundation
import Combine
import Moya
import CoreData
import OfflineSync
import SQLite
import ComposableArchitecture

// MARK: - admin middleware
class KimaiService: DependencyKey {
    enum Mode {
        case live
        case mock
    }
    
    var provider = MoyaProvider<KimaiRequest>()
    var tables: KimaiTable!
    var mode: Mode
    
    var customers: RequestService<KimaiCustomer, KimaiRequest>!
    var projects: RequestService<KimaiProject, KimaiRequest>!
    var timesheets: RequestService<KimaiTimesheet, KimaiRequest>!
    var activities: RequestService<KimaiActivity, KimaiRequest>!
    var teams: RequestService<KimaiTeam, KimaiRequest>!
    var users: RequestService<KimaiUser, KimaiRequest>!
    
    func setAuth(_ account: AccountData) {
        let authPlugin = KimaiAuthPlugin(account.username, account.password)
        provider = MoyaProvider<KimaiRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    func login(_ account: AccountData) async throws -> Bool {
        if let url = URL(string: account.server+"/api") {
            KimaiRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        return true // todo: check auth
    }
    
    func clear(){
        customers.clear()
        projects.clear()
        timesheets.clear()
        activities.clear()
    }
    
    init(_ mode: Mode) {
        self.tables = KimaiTable()
        self.mode = mode
        initRequests()
        
    }
    
    func initRequests(){
        switch(mode){
        case .live:
            customers = .live(
                table: tables.customers,
                provider: provider,
                fetchMethod: .simple(.getCustomers),
                insertMethod: KimaiRequest.insertCustomer,
                updateMethod: KimaiRequest.updateCustomer,
                deleteMethod: nil
            )
            
            projects = .live(
                table: tables.projects,
                provider: provider,
                fetchMethod: .simple(.getProjects),
                insertMethod: KimaiRequest.insertProject,
                updateMethod: KimaiRequest.updateProject,
                deleteMethod: nil
            )
            
            timesheets = .live(
                table: tables.timesheets,
                provider: provider,
                fetchMethod: .page(KimaiRequest.getTimesheets),
                insertMethod: KimaiRequest.insertTimesheet,
                updateMethod: KimaiRequest.updateTimesheet,
                deleteMethod: KimaiRequest.deleteTimesheet
            )
            
            activities = .live(
                table: tables.activities,
                provider: provider,
                fetchMethod: .simple(.getActivities)
            )
            
            teams = .live(
                table: tables.teams,
                provider: provider,
                fetchMethod: .simple(.getTeams)
            )
            
            users = .live(
                table: tables.users,
                provider: provider,
                fetchMethod: .simple(.getUsers)
            )
        case .mock:
            customers = .mock(table: tables.customers)
            projects = .mock(table: tables.projects)
            timesheets = .mock(table: tables.timesheets)
            activities = .mock(table: tables.activities)
            teams = .mock(table: tables.teams)
            users = .mock(table: tables.users)
        }
    }
}

struct KimaiAuthPlugin: PluginType {
    let user: String
    let token: String
    
    init(_ user: String, _ token: String) {
        self.user = user
        self.token = token
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // Add USER header
        request.addValue(user, forHTTPHeaderField: "X-AUTH-USER")
        
        // Add TOKEN header
        request.addValue(token, forHTTPHeaderField: "X-AUTH-TOKEN")
        
        return request
    }
}


extension KimaiService {
    static var liveValue: KimaiService {
        .init(.live)
    }
    
    static var testValue: KimaiService {
        .init(.mock)
    }
}

extension DependencyValues {
    var kimai: KimaiService {
        get { self[KimaiService.self] }
        set { self[KimaiService.self] = newValue }
    }
}


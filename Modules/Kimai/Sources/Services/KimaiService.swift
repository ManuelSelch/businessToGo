import Foundation
import Combine
import Moya
import CoreData
import OfflineSync
import SQLite
import Dependencies

import NetworkFoundation
import KimaiCore
import CommonCore

// MARK: - admin middleware
public class KimaiService {
    enum Mode {
        case live
        case mock
    }
    
    var provider = MoyaProvider<KimaiRequest>()
    var tables: KimaiTable!
    var mode: Mode
    
    public var customers: RequestService<KimaiCustomer, KimaiRequest>!
    public var projects: RequestService<KimaiProject, KimaiRequest>!
    public var timesheets: RequestService<KimaiTimesheet, KimaiRequest>!
    public var activities: RequestService<KimaiActivity, KimaiRequest>!
    public var teams: RequestService<KimaiTeam, KimaiRequest>!
    public var users: RequestService<KimaiUser, KimaiRequest>!
    
    public func setAuth(username: String, password: String) {
        let authPlugin = KimaiAuthPlugin(username, password)
        provider = MoyaProvider<KimaiRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    public func login(server: String) async throws -> Bool {
        if let url = URL(string: server+"/api") {
            KimaiRequest.server = url
        }else {
            throw NetworkError.urlDecodeFailed
        }
        
        return true // todo: check auth
    }
    
    public func clear(){
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
    
    public func initRequests(){
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

struct KimaiServiceKey: DependencyKey {
    static var liveValue = KimaiService(.live)
    static var mockValue = KimaiService(.mock)
}

public extension DependencyValues {
    var kimai: KimaiService {
        get { Self[KimaiServiceKey.self] }
        set { Self[KimaiServiceKey.self] = newValue }
    }
}


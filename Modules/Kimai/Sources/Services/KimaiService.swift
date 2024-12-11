import Foundation
import Combine
import Moya
import CoreData
import OfflineSyncServices
import SQLite
import Dependencies

import NetworkFoundation
import KimaiCore
import CommonCore

// Customers -> Projects -> Activities -> Timesheets
extension KeyMappingTable {
    static let shared = KeyMappingTable(
        relationships: [
            "kimai_projects": [("customer", "kimai_customers")],
            "kimai_activities": [("project", "kimai_projects")],
            "kimai_timesheets": [("project", "kimai_projects"), ("activity", "kimai_activities")]
        ]
    )
}

public struct KimaiService {
    public var customers: KimaiCustomerService
    public var projects: RecordService<KimaiProject>
    public var timesheets: RecordService<KimaiTimesheet>
    public var activities: RecordService<KimaiActivity>
    public var users: RecordService<KimaiUser>
    
    public func setAuth(username: String, password: String) {
        let authPlugin = KimaiAuthPlugin(username, password)
        
        customers.setPlugins([authPlugin])
        projects.setPlugins([authPlugin])
        timesheets.setPlugins([authPlugin])
        activities.setPlugins([authPlugin])
        users.setPlugins([authPlugin])
    }
    
    public func login(server: String) async throws -> Bool {
        if let url = URL(string: server+"/api") {
            KimaiAPI.server = url
        }else {
            throw NetworkError.urlDecodeFailed
        }
        
        return true // todo: check auth
    }
}

extension KimaiService {
    static var live = KimaiService(
        customers: KimaiCustomerService.live,
        projects: KimaiProjectService.live,
        timesheets: KimaiTimesheetService.live,
        activities: KimaiActivityService.live,
        users: KimaiUserService.live
    )
    
    static var mock = KimaiService(
        customers: KimaiCustomerService.mock,
        projects: KimaiProjectService.mock,
        timesheets: KimaiTimesheetService.mock,
        activities: KimaiActivityService.mock,
        users: KimaiUserService.mock
    )
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
        request.addValue(user, forHTTPHeaderField: "X-AUTH-USER")
        request.addValue(token, forHTTPHeaderField: "X-AUTH-TOKEN")
        // request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

struct KimaiServiceKey: DependencyKey {
    static var liveValue = KimaiService.live
    static var mockValue = KimaiService.mock
}

public extension DependencyValues {
    var kimai: KimaiService {
        get { Self[KimaiServiceKey.self] }
        set { Self[KimaiServiceKey.self] = newValue }
    }
}


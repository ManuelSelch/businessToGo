import Foundation
import Combine
import Moya
import SQLite
import Dependencies

import OfflineSyncCore
import OfflineSyncServices

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

public class KimaiService {
    public var customers: KimaiCustomerService
    public var projects: RecordService<KimaiProject>
    public var timesheets: RecordService<KimaiTimesheet>
    public var activities: RecordService<KimaiActivity>
    public var users: RecordService<KimaiUser>
    
    private var user: String = ""
    private var token: String = ""
    
    init(
        customers: KimaiCustomerService,
        projects: RecordService<KimaiProject>,
        timesheets: RecordService<KimaiTimesheet>,
        activities: RecordService<KimaiActivity>,
        users: RecordService<KimaiUser>
    ) {
        self.customers = customers
        self.projects = projects
        self.timesheets = timesheets
        self.activities = activities
        self.users = users

        let authPlugin = KimaiAuthPlugin({self.user}, {self.token})
        customers.setPlugins([authPlugin])
        projects.setPlugins([authPlugin])
        timesheets.setPlugins([authPlugin])
        activities.setPlugins([authPlugin])
        users.setPlugins([authPlugin])
    }
    
    public func setAuth(username: String, password: String) {
        self.user = username
        self.token = password
    }
    
    public func login(server: String) async throws -> Bool {
        if let url = URL(string: server+"/api") {
            KimaiAPI.server = url
        }else {
            throw NetworkError.urlDecodeFailed
        }
        
        return true // todo: check auth
    }
    
    public func save(_ model: any TableProtocol) {
        if let customer = model as? KimaiCustomer {
            if(customer.id == -1) {
                customers.createCustomer(customer)
            } else {
                customers.updateCustomer(customer)
            }
        } else if let project = model as? KimaiProject {
            if(project.id == -1) {
                projects.create(project)
            } else {
                projects.update(project)
            }
        } else if let timesheet = model as? KimaiTimesheet {
            if(timesheet.id == -1) {
                timesheets.create(timesheet)
            } else {
                timesheets.update(timesheet)
            }
        } else if let activity = model as? KimaiActivity {
            if(activity.id == -1) {
                activities.create(activity)
            } else {
                activities.update(activity)
            }
        } else if let user = model as? KimaiUser {
            if(user.id == -1) {
                users.create(user)
            } else {
                users.update(user)
            }
        }
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

class AuthProvider {
    var user: String
    var token: String
    
    init(user: String, token: String) {
        self.user = user
        self.token = token
    }
    
    
}

struct KimaiAuthPlugin: PluginType {
    let getUser: () -> String
    let getToken: () -> String
    
    init(_ getUser: @escaping () -> String, _ getToken: @escaping () -> String) {
        self.getUser = getUser
        self.getToken = getToken
    }
    
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue(getUser(), forHTTPHeaderField: "X-AUTH-USER")
        request.addValue(getToken(), forHTTPHeaderField: "X-AUTH-TOKEN")
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


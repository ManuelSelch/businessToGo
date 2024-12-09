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

public struct KimaiService {
    @Dependency(\.customers) public var customers
    @Dependency(\.projects) public var projects
    @Dependency(\.timesheets) public var timesheets
    @Dependency(\.activities) public var activities
    @Dependency(\.users) public var users
    
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
    static var live = KimaiService()
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
        // request.addValue(user, forHTTPHeaderField: "X-AUTH-USER")
        // request.addValue(token, forHTTPHeaderField: "X-AUTH-TOKEN")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

struct KimaiServiceKey: DependencyKey {
    static var liveValue = KimaiService.live
    static var mockValue = KimaiService.live
}

public extension DependencyValues {
    var kimai: KimaiService {
        get { Self[KimaiServiceKey.self] }
        set { Self[KimaiServiceKey.self] = newValue }
    }
}


import Foundation
import Combine
import Moya
import CoreData
import OfflineSync
import SQLite

// MARK: - admin middleware
class KimaiService {
    var provider = MoyaProvider<KimaiRequest>()
    var tables: KimaiTable
    
    var customers: RequestService<KimaiCustomer, KimaiRequest>!
    var projects: RequestService<KimaiProject, KimaiRequest>!
    var timesheets: RequestService<KimaiTimesheet, KimaiRequest>!
    var activities: RequestService<KimaiActivity, KimaiRequest>!
    var teams: RequestService<KimaiTeam, KimaiRequest>!
    
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
    
    init(_ db: Connection?, _ track: TrackTable) {
        let tables = KimaiTable(db, track)
        self.tables = tables
        initRequests()
      
    }
    
    func initRequests(){
        customers = RequestService(
            tables.customers, provider, .simple(.getCustomers),
            KimaiRequest.insertCustomer, KimaiRequest.updateCustomer
        )
        
        projects = RequestService<KimaiProject, KimaiRequest>(
            tables.projects, provider, .simple(.getProjects),
            KimaiRequest.insertProject, KimaiRequest.updateProject
        )
        
        timesheets = RequestService<KimaiTimesheet, KimaiRequest>(
            tables.timesheets, provider, .page(KimaiRequest.getTimesheets),
            KimaiRequest.insertTimesheet, KimaiRequest.updateTimesheet, KimaiRequest.deleteTimesheet
        )
        
        activities = RequestService<KimaiActivity, KimaiRequest>(
            tables.activities, provider, .simple(.getActivities)
        )
        
        teams = RequestService<KimaiTeam, KimaiRequest>(
            tables.teams, provider, .simple(.getTeams)
        )
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

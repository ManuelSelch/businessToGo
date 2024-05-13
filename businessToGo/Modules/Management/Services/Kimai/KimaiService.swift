import Foundation
import Combine
import Moya
import CoreData
import OfflineSync

// MARK: - admin middleware
class KimaiService {
    private var db: IDatabase
    private var tables: KimaiTable
    private var provider = MoyaProvider<KimaiRequest>()
    
    var customers: RequestService<KimaiCustomer, KimaiRequest>
    var projects: RequestService<KimaiProject, KimaiRequest>
    var timesheets: RequestService<KimaiTimesheet, KimaiRequest>
    var activities: RequestService<KimaiActivity, KimaiRequest>
    
    init(_ db: IDatabase, _ track: TrackTable) {
        self.db = db
        
        tables = KimaiTable(db, track)
        
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
    }
    
    func login(_ account: AccountData) async throws -> Bool {
        let authPlugin = KimaiAuthPlugin(account.username, account.password)
        self.provider = MoyaProvider<KimaiRequest>(plugins: [authPlugin])
        if let url = URL(string: account.server+"/api") {
            KimaiRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        initRequests()
        
        return true // todo: check auth
    }
    
    func clear(){
        customers.clear()
        projects.clear()
        timesheets.clear()
        activities.clear()
    }
}

class KimaiAuthPlugin: PluginType {
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

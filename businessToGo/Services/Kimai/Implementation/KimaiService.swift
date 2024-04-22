import Foundation
import Combine
import Moya
import CoreData

// init<U: IRequestService>(_ service: U) where U.Table == Table, U.Target == Target, U.Input == Input {



// MARK: - admin middleware
class KimaiService: IKimaiService {
    private var db: IDatabase
    private var tables: KimaiTable
    private var provider = MoyaProvider<KimaiRequest>()
    
    var customers: IRequestService<KimaiCustomer, KimaiRequest>
    var projects: IRequestService<KimaiProject, KimaiRequest>
    var timesheets: IRequestService<KimaiTimesheet, KimaiRequest>
    var activities: IRequestService<KimaiActivity, KimaiRequest>
    
    init(_ db: IDatabase, _ track: ITrackTable) {
        self.db = db
        
        tables = KimaiTable(db, track)
        
        customers = RequestService(
            tables.customers, provider, .getCustomers
        )
        
        projects = RequestService<KimaiProject, KimaiRequest>(
            tables.projects, provider, .getProjects
        )
        
        timesheets = RequestService<KimaiTimesheet, KimaiRequest>(
            tables.timesheets, provider, .getTimesheets,
            KimaiRequest.insertTimesheet
        )
        
        activities = RequestService<KimaiActivity, KimaiRequest>(
            tables.activities, provider, .getActivities
        )
    }
    
    func initRequests(){
        customers = RequestService(
            tables.customers, provider, .getCustomers
        )
        
        projects = RequestService<KimaiProject, KimaiRequest>(
            tables.projects, provider, .getProjects
        )
        
        timesheets = RequestService<KimaiTimesheet, KimaiRequest>(
            tables.timesheets, provider, .getTimesheets,
            KimaiRequest.insertTimesheet
        )
        
        activities = RequestService<KimaiActivity, KimaiRequest>(
            tables.activities, provider, .getActivities
        )
    }
    
    func login(_ username: String, _ password: String) -> AnyPublisher<Bool, Error> {
        let authPlugin = KimaiAuthPlugin(username, password)
        self.provider = MoyaProvider<KimaiRequest>(plugins: [authPlugin])
        
        initRequests()
        
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func createTimesheet(_ project: Int, _ activity: Int, _ begin: String, _ description: String?) {
        let timesheet = KimaiTimesheet(project, activity, begin, description)
        timesheets.add(timesheet)
    }
}

// MARK: - mock
extension KimaiService {
    static let mock = KimaiServiceMock()
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

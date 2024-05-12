import Combine
import OfflineSync

protocol IKimaiService  {
    func login(_ account: AccountData) async throws -> Bool
    func clear()
    
    var customers: RequestService<KimaiCustomer, KimaiRequest> { get }
    var projects: RequestService<KimaiProject, KimaiRequest> { get }
    var timesheets: RequestService<KimaiTimesheet, KimaiRequest> { get }
    var activities: RequestService<KimaiActivity, KimaiRequest> { get }
}


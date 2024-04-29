import Combine
import OfflineSync

protocol IKimaiService  {
    func login(_ username: String, _ password: String) -> AnyPublisher<Bool, Error>
    
    var customers: IRequestService<KimaiCustomer, KimaiRequest> { get }
    var projects: IRequestService<KimaiProject, KimaiRequest> { get }
    var timesheets: IRequestService<KimaiTimesheet, KimaiRequest> { get }
    var activities: IRequestService<KimaiActivity, KimaiRequest> { get }
}


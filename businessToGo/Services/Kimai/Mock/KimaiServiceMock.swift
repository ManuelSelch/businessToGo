import Combine


class KimaiServiceMock: IKimaiService {
    var customers: IRequestService<KimaiCustomer, KimaiRequest>
    var projects: IRequestService<KimaiProject, KimaiRequest>
    var timesheets: IRequestService<KimaiTimesheet, KimaiRequest>
    var activities: IRequestService<KimaiActivity, KimaiRequest>
    
    init(){
        customers = IRequestService()
        projects = IRequestService()
        timesheets = IRequestService()
        activities = IRequestService()
    }
        
    func login(_ username: String, _ password: String) -> AnyPublisher<Bool, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func createTimesheet(_ project: Int, _ activity: Int, _ begin: String, _ description: String?) {
        
    }
    
    
}


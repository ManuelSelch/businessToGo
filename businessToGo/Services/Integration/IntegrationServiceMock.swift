import Combine

struct IntegrationServiceMock: IIntegrationService {
    func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int) {
        
    }
    
    func getTaigaProject(_ kimaiProject: Int) -> AnyPublisher<Integration?, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func get() -> [Integration] {
        return []
    }
    
    
}

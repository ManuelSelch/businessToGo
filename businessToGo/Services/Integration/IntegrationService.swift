import Combine
import Redux
import OfflineSync

struct IntegrationService: IIntegrationService, IService {
    var integrations: DatabaseTable<Integration>
    
    init(_ db: IDatabase){
        integrations = DatabaseTable<Integration>(db.connection, "integrations")
    }
    
    func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int){
        let integration = Integration(kimaiProjectId, taigaProjectId)
        integrations.insert(integration, isTrack: false)
    }
    
    func getTaigaProject(_ kimaiProject: Int) -> AnyPublisher<Integration?, Error> {
        return just(integrations.get(by: kimaiProject))
    }
    
    func get() -> [Integration] {
        return integrations.get()
    }
    
    func get(by id: Int) -> Integration? {
        return integrations.get(by: id)
    }
}

extension IntegrationService {
    static let mock = IntegrationServiceMock()
}

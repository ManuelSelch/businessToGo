import Combine
import Redux
import OfflineSync
import SQLite

struct IntegrationService: IIntegrationService, IService {
    var integrations: DatabaseTable<Integration>
    
    init(_ db: Connection?){
        integrations = DatabaseTable<Integration>.live(db, "integrations", nil)
    }
    
    func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int){
        let integration = Integration(kimaiProjectId, taigaProjectId)
        integrations.insert(integration, false)
    }
    
    func getTaigaProject(_ kimaiProject: Int) -> AnyPublisher<Integration?, Error> {
        return just(integrations.get(kimaiProject))
    }
    
    func get() -> [Integration] {
        return integrations.getAll()
    }
    
    func get(by id: Int) -> Integration? {
        return integrations.get(id)
    }
}

extension IntegrationService {
    static let mock = IntegrationServiceMock()
}

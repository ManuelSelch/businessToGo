import Redux
import OfflineSync
import SQLite
import ComposableArchitecture

class IntegrationService: IService, DependencyKey {
    var integrations: DatabaseTable<Integration>!
    
    init(){
        integrations = DatabaseTable<Integration>("integrations")
    }
    
    func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int){
        let integration = Integration(kimaiProjectId, taigaProjectId)
        integrations.insert(integration, isTrack: false)
    }
    
    func get() -> [Integration] {
        return integrations.get()
    }
    
    func get(by id: Int) -> Integration? {
        return integrations.get(by: id)
    }
}

extension IntegrationService {
    static var liveValue: IntegrationService {
        .init()
    }
    
    static var testValue: IntegrationService {
        .init()
    }
}


extension DependencyValues {
    var integrations: IntegrationService {
        get { self[IntegrationService.self] }
        set { self[IntegrationService.self] = newValue }
    }
}

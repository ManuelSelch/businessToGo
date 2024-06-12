import Dependencies
import OfflineSync
import SQLite

import ManagementCore

public class IntegrationService {
    var integrations: DatabaseTable<Integration>!
    
    init(){
        integrations = DatabaseTable<Integration>("integrations")
    }
    
    public func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int){
        let integration = Integration(kimaiProjectId, taigaProjectId)
        integrations.insert(integration, isTrack: false)
    }
    
    public func get() -> [Integration] {
        return integrations.get()
    }
    
    public func get(by id: Int) -> Integration? {
        return integrations.get(by: id)
    }
}

private struct IntegrationServiceKey: DependencyKey {
    static var liveValue = IntegrationService()
    static var mockValue = IntegrationService()
}


public extension DependencyValues {
    var integrations: IntegrationService {
        get { Self[IntegrationServiceKey.self] }
        set { Self[IntegrationServiceKey.self] = newValue }
    }
}




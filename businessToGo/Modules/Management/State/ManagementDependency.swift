import SwiftUI
import Redux
import OfflineSync

extension ManagementModule {
    class Dependency {
        private var db: Database
        
        var track: TrackTable
        
        var kimai: KimaiService!
        var taiga: TaigaService!
        var integrations: IntegrationService!
        
        func reset() {
            db.reset()
        }
        
        func switchDB(_ name: String) {
            print("switch db to: \(name)")
            db = db.switchDB(name)
            initServices()
        }
        
        init(_ db: Database){
            self.db = db
            self.track = TrackTable(db.connection)
            initServices()
            
        }
        
        private func initServices(){
            kimai = KimaiService(db.connection, track)
            taiga = TaigaService(db.connection, track)
            integrations = IntegrationService(db.connection)
        }
    }
    
    
}

extension ManagementModule.Dependency {
    static let live = ManagementModule.Dependency(.none)
    static let mock = ManagementModule.Dependency(.mock)
}

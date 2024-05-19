import SwiftUI
import Redux
import OfflineSync

extension ManagementModule {
    class Dependency {
        var track: TrackTable
        var db: IDatabase
        
        var kimai: KimaiService
        var taiga: TaigaService
        var integrations: IIntegrationService
        
        init(){
            db = Database("businessToGo")
            track = TrackTable(db.connection)
            
            kimai = KimaiService(db, track)
            taiga = TaigaService(db, track)
            integrations = IntegrationService(db)
        }
        
        func reset(){
            db.reset()
            
            track = TrackTable(db.connection)
            kimai = KimaiService(db, track)
            taiga = TaigaService(db, track)
            integrations = IntegrationService(db)
            
            track.clear()
            kimai.clear()
            taiga.clear()
        }
        
        func changeDB(_ name: String){
            db = Database(name)
            
            track = TrackTable(db.connection)
            kimai = KimaiService(db, track)
            taiga = TaigaService(db, track)
            integrations = IntegrationService(db)
        }
    }
}

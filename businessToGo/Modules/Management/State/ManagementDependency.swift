import SwiftUI
import Redux
import OfflineSync

class ManagementDependency: IService {
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

class ManagementRouter: Router {
    @Published var routes: [ManagementRoute] = []
    
    var title: String {
        switch(routes.last){
        case .kimai(let kimai):
            switch(kimai){
            case .customers: return "Kunden"
            case .customer(_): return "Kunde"
            case .project(_): return "Projekt"
            }
        case .taiga(let taiga):
            switch(taiga){
            case .project(_): return "Projekt"
            }
        case .none: return "Kunden"
        }
    }
}

import SwiftUI
import Redux
import OfflineSync

extension ManagementModule {
    struct Dependency {
        var track: TrackTable
        
        var kimai: KimaiService
        var taiga: TaigaService
        var integrations: IIntegrationService
        
        var reset: () -> ()
        var switchDB: (String) -> ()
    }
    
    
}

extension ManagementModule.Dependency {
    static var live: Self {
        var db = Database.live("businessToGo")
        let track = TrackTable(db.connection())
        
        return Self(
            track: track,
            kimai: .live(db.connection(), track),
            taiga: .live(db.connection(), track),
            integrations: IntegrationService(db.connection()),
            reset: {
                db.reset()
            },
            switchDB: { name in
                db = .live(name)
            }
        )
    }
    
    static var mock: Self {
        var db = Database.mock
        let track = TrackTable(db.connection())
        
        return Self(
            track: track,
            kimai: .live(db.connection(), track),
            taiga: .live(db.connection(), track),
            integrations: IntegrationService(db.connection()),
            reset: {
                db.reset()
            },
            switchDB: { name in
                db = .mock
            }
        )
    }
}

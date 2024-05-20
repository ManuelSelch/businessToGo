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
        var db = Database.mock
        let track = TrackTable(db.connection())
        
        var kimai = KimaiService.live(db.connection(), track)
        var taiga = TaigaService.live(db.connection(), track)
        var integrations = IntegrationService(db.connection())
        
        return Self(
            track: track,
            kimai: kimai,
            taiga: taiga,
            integrations: integrations,
            reset: {
                db.reset()
            },
            switchDB: { name in
                print("switch db to: \(name)")
                db = .live(name)
                
                kimai = KimaiService.live(db.connection(), track)
                taiga = TaigaService.live(db.connection(), track)
                integrations = IntegrationService(db.connection())
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

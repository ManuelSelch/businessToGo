import Foundation
import OfflineSync

enum KimaiAction {
    case sync
    
    case customers(RequestAction<KimaiCustomer>)
    case projects(RequestAction<KimaiProject>)
    case timesheets(RequestAction<KimaiTimesheet>)
    case activities(RequestAction<KimaiActivity>)
    case teams(RequestAction<KimaiTeam>)
}

enum RequestAction<Model> {
    /// sync by remote data
    case sync
    /// set synced records
    case set([Model])
    
    /// create local record
    case create(Model)
    /// update local record
    case update(Model)
    /// delete local record
    case delete(Model)
}

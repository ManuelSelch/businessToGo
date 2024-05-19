import Foundation

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

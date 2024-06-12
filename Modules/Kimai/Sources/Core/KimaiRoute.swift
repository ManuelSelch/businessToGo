import Foundation

public enum KimaiRoute: Hashable, Codable, Equatable {
    case customersList
    case customerSheet(KimaiCustomer)
    
    case projectsList(_ customer: Int)
    case projectSheet(KimaiProject)
    case projectDetail(KimaiProject)
    
    case timesheetSheet(KimaiTimesheet)
}

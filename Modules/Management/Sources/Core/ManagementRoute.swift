import Foundation
import KimaiCore
import TaigaCore

public enum ManagementRoute: Identifiable, Hashable, Codable, Equatable {
    case kimai(KimaiRoute)
    case taiga(TaigaRoute)
    case assistant
    
    public var id: Self {self}
}

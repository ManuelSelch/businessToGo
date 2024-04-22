import Foundation

struct DatabaseChange: Equatable {
    var id: Int
    var type: DatabaseChangeType
    var recordID: Int
    var tableName: String
    var timestamp: String
}

enum DatabaseChangeType: Int {
    /// locally updated record
    case update = 0
    /// locally inserted record
    case insert = 1
    /// locally deleted record
    case delete = 2
}

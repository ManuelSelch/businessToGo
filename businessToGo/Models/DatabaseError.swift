import Foundation

enum DatabaseError: Error {
    case notExist
    case insertError(String)
    case getError
}

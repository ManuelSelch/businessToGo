import Foundation

public enum DatabaseError: Error {
    case notExist
    case insertError(String)
    case getError
}

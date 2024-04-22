import Foundation

enum ServiceError: Error {
    case unknown(_ message: String)
    
    case tokenMissing
    case decodeFailed
    
    case keychainReadFailed
    case keychainSaveFailed
}

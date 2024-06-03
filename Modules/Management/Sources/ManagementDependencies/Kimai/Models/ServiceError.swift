import Foundation

public enum ServiceError: Error {
    case unknown(_ message: String)
    
    case tokenMissing
    case decodeFailed
    case urlDecodeFailed
    
    case keychainReadFailed
    case keychainSaveFailed
}

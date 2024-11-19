import Foundation

public enum NetworkError: Error {
    case unknown(_ message: String)
    
    case tokenMissing
    case decodeFailed
    case urlDecodeFailed
}

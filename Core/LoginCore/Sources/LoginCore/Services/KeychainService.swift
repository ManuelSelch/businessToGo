import Foundation
import Dependencies
import LoginService

struct KeychainServiceKey: DependencyKey {
    static var liveValue = KeychainService<Account>.live("de.selch")
    static var mockValue = KeychainService<Account>.mock
}

public extension DependencyValues {
    var keychain: KeychainService<Account> {
        get { Self[KeychainServiceKey.self] }
        set { Self[KeychainServiceKey.self] = newValue }
    }
}

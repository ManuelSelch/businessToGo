import Foundation
import LoginService

public struct Account: IAccount, Hashable {
    public var identifier: String {
        return "\(id)"
    }
    var id: Int
    public var name: String = ""
    public var kimai: AccountData?
    public var taiga: AccountData?
    
}

public struct AccountData: Codable, Hashable {
    public var username: String
    public var password: String
    public var server: String
    
    init(_ username: String, _ password: String, _ server: String) {
        self.username = username
        self.password = password
        self.server = server
    }
}

public extension Account {
    static let demo = Account(
        id: 0,
        name: "DEMO"
    )
}

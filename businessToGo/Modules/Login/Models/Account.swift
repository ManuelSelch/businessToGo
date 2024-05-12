import Foundation
import Login

struct Account: IAccount, Hashable {
    var identifier: String {
        return "\(id)"
    }
    var id: Int
    var name: String = ""
    var kimai: AccountData?
    var taiga: AccountData?
    
}

struct AccountData: Codable, Hashable {
    var username: String
    var password: String
    var server: String
    
    init(_ username: String, _ password: String, _ server: String) {
        self.username = username
        self.password = password
        self.server = server
    }
}

extension Account {
    static let demo = Account(
        id: 0,
        name: "DEMO",
        kimai: AccountData(
            "manuel@selch.de",
            "1Ter6esai#Qabc",
            "https://time.dev.manuelselch.de"
        ),
        taiga: AccountData(
            "user@user.de", 
            "user",
            "https://project.manuelselch.de"
        )
    )
}

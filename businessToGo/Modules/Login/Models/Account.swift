import Foundation

struct Account: Hashable {
    var kimai: AccountData?
    var taiga: AccountData?
    
    init(_ kimai: AccountData?, _ taiga: AccountData?){
        self.kimai = kimai
        self.taiga = taiga
    }
    
    init(){
        
    }
}

struct AccountData: Hashable {
    var username: String
    var password: String
    
    init(_ username: String, _ password: String) {
        self.username = username
        self.password = password
    }
}

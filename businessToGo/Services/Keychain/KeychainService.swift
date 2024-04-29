import Security
import Foundation
import Combine
import Redux

struct KeychainService: IKeychainService, IService {
    let service = "de.selch.businessToGo"
    let kimaiService: String
    let taigaService: String
    
    init(){
        kimaiService = service + ".kimai"
        taigaService = service + ".taiga"
    }
    
    func saveAccount(_ account: Account) -> AnyPublisher<Bool, Error> {
        _ = removeAccount()
        
        return Publishers.Merge(
            saveAccountData(kimaiService, account.kimai),
            saveAccountData(taigaService, account.taiga)
        ).eraseToAnyPublisher()
    }
    
    private func saveAccountData(_ service: String, _ account: AccountData?) -> AnyPublisher<Bool, Error> {
        guard
            let username = account?.username.data(using: .utf8),
            let password = account?.password.data(using: .utf8)
        else {
            return Fail(error: ServiceError.keychainReadFailed).eraseToAnyPublisher()
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]
        
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            return Fail(error: ServiceError.keychainSaveFailed).eraseToAnyPublisher()
        }else{
            return just(true)
        }
    }
    
    func getAccount() -> AnyPublisher<Account, Error> {
        return Publishers.Zip(getAccountData(kimaiService), getAccountData(taigaService))
            .map { kimaiAccount, taigaAccount in
                return Account(kimaiAccount, taigaAccount)
            }
            .eraseToAnyPublisher()
    }
    
    private func getAccountData(_ service: String) -> AnyPublisher<AccountData?, Error> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let item = result as? [String: Any] {
            guard  let usernameData = item[kSecAttrAccount as String]   as? Data else {
                return Fail(error: ServiceError.keychainReadFailed).eraseToAnyPublisher()
            }
            guard  let passwordData = item[kSecValueData as String]     as? Data else {
                return Fail(error: ServiceError.keychainReadFailed).eraseToAnyPublisher()
            }
            
            let username = String(decoding: usernameData, as: UTF8.self)
            let password = String(decoding: passwordData, as: UTF8.self)
            
            let account = AccountData(username, password)
            
            return just(account)
        }else {
            return just(nil)
        }
        
  
    }
    
    func removeAccount() -> AnyPublisher<Account, Error> {
        let delete: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        let status = SecItemDelete(delete as CFDictionary)
        LogService.log("Delete status: \(status)")
        
        return just(Account())
    }
}

// MARK: - mock
extension KeychainService {
    static let mock = KeychainServiceMock()
}

import Combine

struct KeychainServiceMock: IKeychainService {
    func saveAccount(_ account: Account) -> AnyPublisher<Bool, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func getAccount() -> AnyPublisher<Account, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func removeAccount() -> AnyPublisher<Account, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    
    
    
}

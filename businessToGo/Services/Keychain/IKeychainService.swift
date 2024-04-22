import Combine

protocol IKeychainService {
    func saveAccount(_ account: Account) -> AnyPublisher<Bool, Error>
    func getAccount() -> AnyPublisher<Account, Error>
    func removeAccount() -> AnyPublisher<Account, Error>
}


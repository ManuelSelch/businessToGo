import Foundation
import Combine
import Moya
import OfflineSync
import Log
import Redux
import Login

class Environment {
    // MARK: - global
    var router: AppRouter = .init()
    
    // MARK: - modules
    var log: Log.LogDependency = .init()
    var management: ManagementDependency = .init()
    
    // MARK: - services
    var keychain: KeychainService<Account> = .init("de.selch.businessToGo")
}





// MARK: - helper methods
extension Environment {
    func action(_ action: AppAction) -> AnyPublisher<AppAction, Error> {
        return Just(action)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func just<T>(_ event: T) -> AnyPublisher<T, Error> {
        return Just(event)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func request<Response: Decodable, TargetType>(_ provider: MoyaProvider<TargetType>, _ method: TargetType) -> AnyPublisher<Response, Error> {
        return Future<Response, Error> { promise in
            provider.request(method){ result in
                switch result {
                case .success(let response):
                    if let data = try? JSONDecoder().decode(Response.self, from: response.data) {
                        promise(.success(data))
                    }else {
                        if let string = String(data: response.data, encoding: .utf8) {
                            promise(.failure(ServiceError.unknown(method.path + " -> " + string)))
                        }else{
                            promise(.failure(ServiceError.decodeFailed))
                        }
                    }
                case .failure(let error):
                    promise(.failure(ServiceError.unknown(method.path + " -> " + error.localizedDescription)))
                }
            }
        }.eraseToAnyPublisher()
    }
}

class AppRouter: ObservableObject {
    @Published var tab = AppScreen.login
    
    var management = ManagementRouter()
    var settings = SettingsRouter()
}

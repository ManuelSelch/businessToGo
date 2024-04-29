import Foundation
import Combine
import Moya
import OfflineSync
import Log
import Redux

struct ManagementDependency: IService {
    var kimai: IKimaiService
    var taiga: ITaigaService
    var integrations: IIntegrationService
}

extension ManagementDependency {
    init(_ db: IDatabase, _ track: ITrackTable){
        kimai = KimaiService(db, track)
        taiga = TaigaService(db, track)
        integrations = IntegrationService(db)
    }
    
    static let mock = ManagementDependency(kimai: KimaiService.mock, taiga: TaigaService.mock, integrations: IntegrationService.mock)
}


struct Environment {
    // MARK: - global
    private let db: IDatabase
    var router: AppRouter
    let track: ITrackTable
    
    // MARK: - modules
    let log: Log.Dependency
    let management: ManagementDependency
    
    // MARK: - services
    var keychain: IKeychainService
    
    func reset(){
        db.reset()
    }
    
    // MARK: - mock
    static let mock = Environment(
        db: Database.mock,
        router: .init(),
        track: TrackTable.mock,
        
        log: .init(),
        management: .mock,
        
        keychain: KeychainService.mock
    )
}

extension Environment {
    init(){
        db = Database("businessToGo")
        router = .init()
        track = TrackTable(Database("track").connection)
        
        log = .init()
        management = .init(db, track)
        
        keychain = KeychainService()
    }
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

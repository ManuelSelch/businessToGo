import Foundation
import Dependencies
import OfflineSyncCore
import OfflineSyncServices
import Moya


public class PageRequestService<Model: TableProtocol, API: TargetType>: RequestService<Model, API> {
    var fetchPageMethod: (Int) -> API
    
    init(
        fetchMethod: @escaping (Int) -> API,
        insertMethod: ((Model) -> API)? = nil,
        updateMethod: ((Model) -> API)? = nil,
        deleteMethod: ((Int) -> API)? = nil,
        
        provider: MoyaProvider<API>,
        _setPlugins: @escaping ([PluginType]) -> MoyaProvider<API>
    ) {
        self.fetchPageMethod = fetchMethod
        
        super.init(
            fetchMethod: nil,
            insertMethod: insertMethod,
            updateMethod: updateMethod,
            deleteMethod: deleteMethod,
            
            provider: provider,
            _setPlugins: _setPlugins
        )
    }
    
    override public func fetch() async throws -> [Model] {
        var records: [Model] = []
        
        let (response, headers): ([Model]?, [AnyHashable:Any]) = try await requestWithHeaders(provider, fetchPageMethod(1))
        if let response = response {
            records.append(contentsOf: response)
        }
        
        if let pages = headers["x-total-pages"] as? Int {
            for i in 2...pages {
                if let result: [Model] = try await request(provider, fetchPageMethod(i)) {
                    records.append(contentsOf: result)
                }
            }
        }
        
        return records
    }
    
    func requestWithHeaders<Response: Decodable, TargetType>(_ provider: MoyaProvider<TargetType>, _ method: TargetType) async throws -> (Response?, [AnyHashable:Any]) {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(method){ result in
                switch result {
                case .success(let response):
                    let headers = response.response?.allHeaderFields ?? [:]
                    
                    if (response.statusCode == 204){ // no content
                        continuation.resume(returning: (nil, headers))
                    } else if let data = try? JSONDecoder().decode(Response.self, from: response.data) {
                        continuation.resume(returning: (data, headers))
                    }else {
                        if let string = String(data: response.data, encoding: .utf8) {
                            continuation.resume(throwing: ServiceError.unknown(method.path + " -> " + string))
                        }else{
                            continuation.resume(throwing: ServiceError.decodeFailed)
                        }
                    }
                case .failure(let error):
                    continuation.resume(throwing: ServiceError.unknown(method.path + " -> " + error.localizedDescription))
                }
            }
        }
    }
}

public extension PageRequestService {
    static func live(
        fetchMethod: @escaping (Int) -> API,
        insertMethod: ((Model) -> API)? = nil,
        updateMethod: ((Model) -> API)? = nil,
        deleteMethod: ((Int) -> API)? = nil
    ) -> PageRequestService {
        return .init(
            fetchMethod: fetchMethod,
            insertMethod: insertMethod,
            updateMethod: updateMethod,
            deleteMethod: deleteMethod,
            provider: MoyaProvider<API>(),
            _setPlugins: { plugins in
                return MoyaProvider<API>(plugins: plugins)
            }
        )
    }
    
    static func mock(
        fetchMethod: @escaping (Int) -> API,
        insertMethod: ((Model) -> API)? = nil,
        updateMethod: ((Model) -> API)? = nil,
        deleteMethod: ((Int) -> API)? = nil
    ) -> PageRequestService {
        return .init(
            fetchMethod: fetchMethod,
            insertMethod: insertMethod,
            updateMethod: updateMethod,
            deleteMethod: deleteMethod,
            provider: MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub),
            _setPlugins: { plugins in
                return MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub, plugins: plugins)
            }
        )
    }
}

import Foundation
import Combine
import Moya

public struct Network {
    public static func request<Response: Decodable, TargetType>(_ provider: MoyaProvider<TargetType>, _ method: TargetType) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(method){ result in
                switch result {
                case .success(let response):
                    if let data = try? JSONDecoder().decode(Response.self, from: response.data) {
                        continuation.resume(returning: data)
                    }else {
                        if let string = String(data: response.data, encoding: .utf8) {
                            continuation.resume(throwing: NetworkError.unknown(method.path + " -> " + string))
                        }else{
                            continuation.resume(throwing: NetworkError.decodeFailed)
                        }
                    }
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.unknown(method.path + " -> " + error.localizedDescription))
                }
            }
        }
    }
}

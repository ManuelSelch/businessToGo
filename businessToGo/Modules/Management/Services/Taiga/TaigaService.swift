import Foundation
import Combine
import Moya
import SwiftUI
import Redux
import OfflineSync


class TaigaService: IService {
    private var tables: TaigaTable
    private var provider: MoyaProvider<TaigaRequest>
    
    var projects: RequestService<TaigaProject, TaigaRequest>
    var taskStories: RequestService<TaigaTaskStory, TaigaRequest>
    var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaRequest>
    var milestones: RequestService<TaigaMilestone, TaigaRequest>
    var tasks: RequestService<TaigaTask, TaigaRequest>
    
    
    init(_ db: IDatabase, _ track: TrackTable){
        tables = TaigaTable(db, track)
        provider = MoyaProvider<TaigaRequest>()
        
        projects = RequestService(tables.projects, provider, .simple(.getProjects))
        taskStories = RequestService(
            tables.taskStories, provider,
            .simple(.getTaskStories),
            nil,
            TaigaRequest.updateTaskStory,
            nil
        )
        taskStoryStatus = RequestService(tables.taskStatus, provider, .simple(.getStatusList))
        milestones = RequestService(tables.milestones, provider, .simple(.getMilestones))
        tasks = RequestService(tables.tasks, provider, .simple(.getTasks))
    }
    
   

    
    func login(_ account: AccountData) async throws -> TaigaUserAuthDetail {
        if let url = URL(string: account.server + "/api/v1") {
            TaigaRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        return try await request(provider, .checkLogin(account.username, account.password))
    }
    
    func setToken(_ token: String){
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
        
        projects = RequestService(tables.projects, provider, .simple(.getProjects))
        taskStories = RequestService(
            tables.taskStories, provider,
            .simple(.getTaskStories),
            nil,
            TaigaRequest.updateTaskStory,
            nil
        )
        taskStoryStatus = RequestService(tables.taskStatus, provider, .simple(.getStatusList))
        milestones = RequestService(tables.milestones, provider, .simple(.getMilestones))
        tasks = RequestService(tables.tasks, provider, .simple(.getTasks))
    }
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) async throws -> TaigaTaskStory {
        return try await request(provider, .updateTaskStory(taskStory))
    }
    
    func loadImage(_ url: String?) -> AnyPublisher<CustomImage, Error> {
        return Future<CustomImage, Error> { promise in
            // Image not found, fetch from URL
            if let img = url {
                
                self.loadImageFromURL(urlString: img) { loadedImage in
                    if let loadedImage = loadedImage {
                        promise(.success(loadedImage))
                    }else{
                        promise(.success(CustomImage(named: "taiga")!))
                    }
                }
            }else {
                promise(.success(CustomImage(named: "taiga")!))
            }
        }.eraseToAnyPublisher()
    }
    
    private func loadImageFromURL(urlString: String, completion: @escaping (CustomImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let loadedImage = CustomImage(data: data)
            completion(loadedImage)
        }.resume()
    }
    
    func clear(){
        projects.clear()
        taskStories.clear()
        taskStoryStatus.clear()
        milestones.clear()
        tasks.clear()
    }
}

// todo: merge to redux module 


import Foundation
import Combine
import Moya

@available(iOS 16.0, *)
@available(macOS 12.0, *)
public protocol IService {
     
}

@available(iOS 16.0, *)
@available(macOS 12.0, *)
public extension IService {
    func just<T>(_ event: T) -> AnyPublisher<T, Error> {
        return Just(event)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func request<Response: Decodable, TargetType>(_ provider: MoyaProvider<TargetType>, _ method: TargetType) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(method){ result in
                switch result {
                case .success(let response):
                    if let data = try? JSONDecoder().decode(Response.self, from: response.data) {
                        continuation.resume(returning: data)
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
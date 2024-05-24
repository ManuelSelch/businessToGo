import Foundation
import Combine
import Moya
import SwiftUI
import Redux
import OfflineSync
import SQLite
import ComposableArchitecture

class TaigaService: IService, DependencyKey {    
    var provider = MoyaProvider<TaigaRequest>()
    
    var projects: RequestService<TaigaProject, TaigaRequest>!
    var taskStories: RequestService<TaigaTaskStory, TaigaRequest>!
    var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaRequest>!
    var milestones: RequestService<TaigaMilestone, TaigaRequest>!
    var tasks: RequestService<TaigaTask, TaigaRequest>!
    
    
    func setAuth(_ token: String) {
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
    }
    
    func login(_ account: AccountData) async throws -> TaigaUserAuthDetail {
        if let url = URL(string: account.server + "/api/v1") {
            TaigaRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        return try await request(provider, .checkLogin(account.username, account.password))
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
    
    init() {
        let tables = TaigaTable()
        
        projects = RequestService(
            tables.projects,
            provider,
            .simple(.getProjects)
        )
        taskStories = RequestService(
            tables.taskStories,
            provider,
            .simple(.getTaskStories),
            nil,
            TaigaRequest.updateTaskStory,
            nil
        )
        taskStoryStatus = RequestService(
            tables.taskStatus,
            provider,
            .simple(.getStatusList)
        )
        milestones = RequestService(
            tables.milestones,
            provider,
            .simple(.getMilestones)
        )
        tasks = RequestService(
            tables.tasks,
            provider,
            .simple(.getTasks)
        )
    }
}

extension TaigaService {
    static var liveValue: TaigaService {
        .init()
    }
}

extension DependencyValues {
    var taiga: TaigaService {
        get { self[TaigaService.self] }
        set { self[TaigaService.self] = newValue }
    }
}

import Foundation
import Combine
import Moya
import SwiftUI
import Redux
import OfflineSync
import SQLite

class TaigaService {
    enum Mode {
        case live
        case mock
    }
    
    var provider = MoyaProvider<TaigaRequest>()
    var tables: TaigaTable
    var mode: Mode
    
    var projects: RequestService<TaigaProject, TaigaRequest>!
    var taskStories: RequestService<TaigaTaskStory, TaigaRequest>!
    var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaRequest>!
    var milestones: RequestService<TaigaMilestone, TaigaRequest>!
    var tasks: RequestService<TaigaTask, TaigaRequest>!
    
    
    func setAuth(_ token: String) {
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    func login(_ account: AccountData) async throws -> TaigaUserAuthDetail {
        if let url = URL(string: account.server + "/api/v1") {
            TaigaRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        return try await Service.request(provider, .checkLogin(account.username, account.password))
    }
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) async throws -> TaigaTaskStory {
        return try await Service.request(provider, .updateTaskStory(taskStory))
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
    
    init(_ mode: Mode) {
        self.tables = TaigaTable()
        self.mode = mode
        
        initRequests()
    }
    
    private func initRequests(){
        switch(mode){
        case .live:
            projects = .live(
                table: tables.projects,
                provider: provider,
                fetchMethod: .simple(.getProjects),
                insertMethod: nil,
                updateMethod: nil,
                deleteMethod: nil
            )
            taskStories = .live(
                table: tables.taskStories,
                provider: provider,
                fetchMethod: .simple(.getTaskStories),
                insertMethod: nil,
                updateMethod: TaigaRequest.updateTaskStory,
                deleteMethod: nil
            )
            taskStoryStatus = .live(
                table: tables.taskStatus,
                provider: provider,
                fetchMethod: .simple(.getStatusList),
                insertMethod: nil,
                updateMethod: nil,
                deleteMethod: nil
            )
            milestones = .live(
                table: tables.milestones,
                provider: provider,
                fetchMethod: .simple(.getMilestones),
                insertMethod: nil,
                updateMethod: nil,
                deleteMethod: nil
            )
            tasks = .live(
                table: tables.tasks,
                provider: provider,
                fetchMethod: .simple(.getTasks),
                insertMethod: nil,
                updateMethod: nil,
                deleteMethod: nil
            )
        case .mock:
            projects = .mock(table: tables.projects)
            taskStories = .mock(table: tables.taskStories)
            milestones = .mock(table: tables.milestones)
            tasks = .mock(table: tables.tasks)
        }
    }
}


struct TaigaServiceKey: DependencyKey {
    static var liveValue = TaigaService(.live)
    static var mockValue = TaigaService(.mock)
}

extension DependencyValues {
    var taiga: TaigaService {
        get { Self[TaigaServiceKey.self] }
        set { Self[TaigaServiceKey.self] = newValue }
    }
}

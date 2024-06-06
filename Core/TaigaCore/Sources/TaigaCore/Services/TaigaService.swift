import Foundation
import Combine
import Moya
import SwiftUI
import Dependencies
import OfflineSync
import SQLite

import AppCore

public class TaigaService {
    public enum Mode {
        case live
        case mock
    }
    
    var provider = MoyaProvider<TaigaRequest>()
    var tables: TaigaTable
    var mode: Mode
    
    public var projects: RequestService<TaigaProject, TaigaRequest>!
    public var taskStories: RequestService<TaigaTaskStory, TaigaRequest>!
    public var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaRequest>!
    public var milestones: RequestService<TaigaMilestone, TaigaRequest>!
    public var tasks: RequestService<TaigaTask, TaigaRequest>!
    
    
    public func setAuth(_ token: String) {
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    public func login(username: String, password: String, server: String) async throws -> TaigaUserAuthDetail {
        if let url = URL(string: server + "/api/v1") {
            TaigaRequest.server = url
        }else {
            throw ServiceError.urlDecodeFailed
        }
        
        return try await Service.request(provider, .checkLogin(username, password))
    }
    
    public func updateTaskStory(_ taskStory: TaigaTaskStory) async throws -> TaigaTaskStory {
        return try await Service.request(provider, .updateTaskStory(taskStory))
    }
    
    public func loadImage(_ url: String?) -> AnyPublisher<UIImage, Error> {
        return Future<UIImage, Error> { promise in
            // Image not found, fetch from URL
            if let img = url {
                
                self.loadImageFromURL(urlString: img) { loadedImage in
                    if let loadedImage = loadedImage {
                        promise(.success(loadedImage))
                    }else{
                        promise(.success(UIImage(named: "taiga")!))
                    }
                }
            }else {
                promise(.success(UIImage(named: "taiga")!))
            }
        }.eraseToAnyPublisher()
    }
    
    private func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let loadedImage = UIImage(data: data)
            completion(loadedImage)
        }.resume()
    }
    
    public func clear(){
        projects.clear()
        taskStories.clear()
        taskStoryStatus.clear()
        milestones.clear()
        tasks.clear()
    }
    
    public init(_ mode: Mode) {
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

public extension DependencyValues {
    var taiga: TaigaService {
        get { Self[TaigaServiceKey.self] }
        set { Self[TaigaServiceKey.self] = newValue }
    }
}

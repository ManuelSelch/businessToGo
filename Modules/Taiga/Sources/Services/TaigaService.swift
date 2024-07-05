import Foundation
import Combine
import Moya
import SwiftUI
import Dependencies
import OfflineSync
import SQLite

import NetworkFoundation
import TaigaCore
import CommonCore

public struct TaigaService {
    @Dependency(\.projects) public var projects
    @Dependency(\.taskStories) public var taskStories
    @Dependency(\.taskStoryStatus) public var taskStoryStatus
    @Dependency(\.milestones) public var milestones
    @Dependency(\.tasks) public var tasks
    
    var _setAuth: (String) -> ()
    var _login: (_ username: String, _ password: String, _ server: String) async throws -> TaigaUserAuthDetail
    var _updateTaskStory: (TaigaTaskStory) async throws -> TaigaTaskStory
    var _loadImage: (_ url: String?) async throws -> UIImage
    
    public func setAuth(_ token: String) {
        self._setAuth(token)
    }
    
    public func login(username: String, password: String, server: String) async throws -> TaigaUserAuthDetail {
        return try await self._login(username, password, server)
    }
    
    public func updateTaskStory(_ taskStory: TaigaTaskStory) async throws -> TaigaTaskStory {
        return try await self._updateTaskStory(taskStory)
    }
    
    public func loadImage(_ url: String?) async throws -> UIImage {
        return try await self._loadImage(url)
    }
    
    public func clear(){
        projects.clear()
        taskStories.clear()
        taskStoryStatus.clear()
        milestones.clear()
        tasks.clear()
    }
}

extension TaigaService {
    
    static var live: Self {
        var provider = MoyaProvider<TaigaAPI>()
        
        @Dependency(\.projects) var projects
        @Dependency(\.taskStories) var taskStories
        @Dependency(\.taskStoryStatus) var taskStoryStatus
        @Dependency(\.milestones) var milestones
        @Dependency(\.tasks) var tasks
        
        return Self(
            _setAuth: { token in
                let authPlugin = AccessTokenPlugin { _ in token }
                provider = MoyaProvider<TaigaAPI>(plugins: [authPlugin])
                
                projects.setPlugins([authPlugin])
                taskStories.setPlugins([authPlugin])
                taskStoryStatus.setPlugins([authPlugin])
                milestones.setPlugins([authPlugin])
                tasks.setPlugins([authPlugin])
            },
            _login: { username, password, server in
                if let url = URL(string: server + "/api/v1") {
                    TaigaAPI.server = url
                }else {
                    throw ServiceError.urlDecodeFailed
                }
                
                return try await Network.request(provider, .checkLogin(username, password))
            },
            _updateTaskStory: {
                return try await Network.request(provider, .updateTaskStory($0))
            },
            _loadImage: { urlString in
                guard let urlString = urlString,
                      let url = URL(string: urlString)
                else {
                    throw ServiceError.urlDecodeFailed
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let loadedImage = UIImage(data: data)
                if let loadedImage = loadedImage {
                    return loadedImage
                } else {
                    throw ServiceError.decodeFailed
                }
            }
        )
    }
}

struct TaigaServiceKey: DependencyKey {
    static var liveValue = TaigaService.live
    static var mockValue = TaigaService.live
}

public extension DependencyValues {
    var taiga: TaigaService {
        get { Self[TaigaServiceKey.self] }
        set { Self[TaigaServiceKey.self] = newValue }
    }
}

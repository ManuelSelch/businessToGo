import Foundation
import Combine
import Moya
import SwiftUI
import Redux
import OfflineSync


class TaigaService: ITaigaService, IService {
    private var tables: TaigaTable
    private var provider: MoyaProvider<TaigaRequest>
    
    var projects: IRequestService<TaigaProject, TaigaRequest>
    var taskStories: IRequestService<TaigaTaskStory, TaigaRequest>
    var taskStoryStatus: IRequestService<TaigaTaskStoryStatus, TaigaRequest>
    var milestones: IRequestService<TaigaMilestone, TaigaRequest>
    var tasks: IRequestService<TaigaTask, TaigaRequest>
    
    
    init(_ db: IDatabase, _ track: ITrackTable){
        tables = TaigaTable(db, track)
        provider = MoyaProvider<TaigaRequest>()
        
        projects = RequestService(tables.projects, provider, .getProjects)
        taskStories = RequestService(
            tables.taskStories, provider,
            TaigaRequest.getTaskStories
        )
        taskStoryStatus = RequestService(tables.taskStatus, provider, .getStatusList)
        milestones = RequestService(tables.milestones, provider, .getMilestones)
        tasks = RequestService(tables.tasks, provider, TaigaRequest.getTasks)
    }
    
    func initRequests(){
        projects = RequestService(tables.projects, provider, .getProjects)
        taskStories = RequestService(
            tables.taskStories, provider,
            TaigaRequest.getTaskStories
        )
        taskStoryStatus = RequestService(tables.taskStatus, provider, .getStatusList)
        milestones = RequestService(tables.milestones, provider, .getMilestones)
        tasks = RequestService(tables.tasks, provider, .getTasks)
    }
    

    
    func login(_ username: String, _ password: String) -> AnyPublisher<TaigaUserAuthDetail, Error> {
        return request(provider, .checkLogin(username, password))
    }
    
    func setToken(_ token: String){
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) -> AnyPublisher<TaigaTaskStory, Error> {
        return request(provider, .updateTaskStory(taskStory))
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
}

extension TaigaService {
    static let mock = TaigaServiceMock()
}


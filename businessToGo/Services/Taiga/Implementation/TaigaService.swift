import Foundation
import Combine
import Moya


class TaigaService: ITaigaService {
    private var database = TaigaTable()
    private var provider: MoyaProvider<TaigaRequest>
    
    var projects: IRequestService<TaigaProject, TaigaRequest>
    var taskStories: IRequestService<TaigaTaskStory, TaigaRequest>
    var taskStoryStatus: IRequestService<TaigaTaskStoryStatus, TaigaRequest>
    var milestones: IRequestService<TaigaMilestone, TaigaRequest>
    var tasks: IRequestService<TaigaTask, TaigaRequest>
    
    
    init(){
        provider = MoyaProvider<TaigaRequest>()
        
        projects = RequestService(database.projects, provider, .getProjects)
        taskStories = RequestService(database.taskStories, provider, .getTaskStories)
        taskStoryStatus = RequestService(database.taskStatus, provider, .getStatusList)
        milestones = RequestService(database.milestones, provider, .getMilestones)
        tasks = RequestService(database.tasks, provider, TaigaRequest.getTasks)
    }
    
    func initRequests(){
        projects = RequestService(database.projects, provider, .getProjects)
        taskStories = RequestService(database.taskStories, provider, .getTaskStories)
        taskStoryStatus = RequestService(database.taskStatus, provider, .getStatusList)
        milestones = RequestService(database.milestones, provider, .getMilestones)
        tasks = RequestService(database.tasks, provider, .getTasks)
    }
    

    
    func login(_ username: String, _ password: String) -> AnyPublisher<TaigaUserAuthDetail, Error> {
        return Env.request(provider, .checkLogin(username, password))
    }
    
    func setToken(_ token: String){
        let authPlugin = AccessTokenPlugin { _ in token }
        provider = MoyaProvider<TaigaRequest>(plugins: [authPlugin])
        initRequests()
    }
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) -> AnyPublisher<TaigaTaskStory, Error> {
        return Env.request(provider, .updateTaskStory(taskStory))
    }
    
    func loadImage(_ url: String?) -> AnyPublisher<UIImage, Error> {
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
}

extension TaigaService {
    static let mock = TaigaServiceMock()
}


import Combine
import SwiftUI


class TaigaServiceMock: ITaigaService {
    var projects: IRequestService<TaigaProject, TaigaRequest>
    var taskStories: IRequestService<TaigaTaskStory, TaigaRequest>
    var taskStoryStatus: IRequestService<TaigaTaskStoryStatus, TaigaRequest>
    var milestones: IRequestService<TaigaMilestone, TaigaRequest>
    var tasks: IRequestService<TaigaTask, TaigaRequest>
    
    init(){
        projects = IRequestService()
        taskStories = IRequestService()
        taskStoryStatus = IRequestService()
        milestones = IRequestService()
        tasks = IRequestService()
    }
    
    
    
    func login(_ username: String, _ password: String) -> AnyPublisher<TaigaUserAuthDetail, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    
    func setToken(_ token: String) {
        
    }
    
    
    func reset(){
        
    }
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) -> AnyPublisher<TaigaTaskStory, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func loadImage(_ url: String?) -> AnyPublisher<UIImage, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    
}


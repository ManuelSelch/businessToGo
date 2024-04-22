import Combine
import SwiftUI


protocol ITaigaService {
    var projects: IRequestService<TaigaProject, TaigaRequest> {get}
    var taskStories: IRequestService<TaigaTaskStory, TaigaRequest> {get}
    var taskStoryStatus: IRequestService<TaigaTaskStoryStatus, TaigaRequest> {get}
    var milestones: IRequestService<TaigaMilestone, TaigaRequest> {get}
    var tasks: IRequestService<TaigaTask, TaigaRequest> {get}

    
    func login(_ username: String, _ password: String) -> AnyPublisher<TaigaUserAuthDetail, Error>
    
    func setToken(_ token: String)
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) -> AnyPublisher<TaigaTaskStory, Error> 
    func loadImage(_ url: String?) -> AnyPublisher<UIImage, Error>
}


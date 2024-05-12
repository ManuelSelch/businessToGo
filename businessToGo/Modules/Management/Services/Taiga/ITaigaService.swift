import Combine
import OfflineSync
import SwiftUI

protocol ITaigaService {
    var projects: RequestService<TaigaProject, TaigaRequest> {get}
    var taskStories: RequestService<TaigaTaskStory, TaigaRequest> {get}
    var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaRequest> {get}
    var milestones: RequestService<TaigaMilestone, TaigaRequest> {get}
    var tasks: RequestService<TaigaTask, TaigaRequest> {get}

    
    func login(_ account: AccountData) async throws -> TaigaUserAuthDetail
    
    func setToken(_ token: String)
    
    func updateTaskStory(_ taskStory: TaigaTaskStory) async throws -> TaigaTaskStory
    func loadImage(_ url: String?) -> AnyPublisher<CustomImage, Error>
    
    func clear()
}


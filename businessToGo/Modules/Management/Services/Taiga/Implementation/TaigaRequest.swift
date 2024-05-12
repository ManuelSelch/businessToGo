import Foundation
import Moya

enum TaigaRequest {
    case checkLogin(_ username: String, _ password: String)
    
    case getProjects
    case getStatusList
    case getTaskStories
    case getTasks
    case getMilestones
    
    case updateTaskStory(TaigaTaskStory)
}
 
extension TaigaRequest: TargetType, AccessTokenAuthorizable {
    var task: Moya.Task {
        switch self{
        case .getProjects, .getStatusList, .getTaskStories, .getTasks, .getMilestones:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var path: String {
        switch self {
        case .checkLogin(_, _):
            return "/auth"
            
        case .getProjects:
            return "/projects"
        case .getStatusList:
            return "/userstory-statuses"
        case .getTaskStories:
            return "/userstories"
        case .getTasks:
            return "/tasks"
        case .getMilestones:
            return "/milestones"
            
        case .updateTaskStory(let taskStory):
            return "/userstories/\(taskStory.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkLogin(_, _):
            return .post
        case .getProjects, .getStatusList, .getTaskStories, .getTasks, .getMilestones:
            return .get
        case .updateTaskStory(_):
            return .patch
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .checkLogin(let username, let password):
            return [
                "username": username,
                "password": password,
                "type": "normal"
            ]
            
        case .getProjects, .getStatusList, .getTaskStories, .getTasks, .getMilestones:
            return [:]
            
        case .updateTaskStory(let taskStory):
            return [
                "version": taskStory.version,
                "subject": taskStory.subject,
                "status": taskStory.status
            ]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self{
        case .checkLogin(_, _):
            return .none
        default:
            return .bearer
        }
    }
    
    
    
    // MARK: - default parameters
    
    var baseURL: URL {
        return TaigaRequest.server
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    
    var validate: Bool {
        return true
    }
}

extension TaigaRequest {
    static var server =  URL(string: "https://project.manuelselch.de/api/v1")!
}

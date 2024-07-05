import Foundation
import Moya

import TaigaCore

public enum TaigaAPI {
    case checkLogin(_ username: String, _ password: String)
    
    case getProjects
    case getStatusList
    case getTaskStories
    case getTasks
    case getMilestones
    
    case updateTaskStory(TaigaTaskStory)
}
 
extension TaigaAPI: TargetType, AccessTokenAuthorizable {
    public var task: Moya.Task {
        switch self{
        case .getProjects, .getStatusList, .getTaskStories, .getTasks, .getMilestones:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var path: String {
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
    
    public var method: Moya.Method {
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
    
    public var authorizationType: AuthorizationType? {
        switch self{
        case .checkLogin(_, _):
            return .none
        default:
            return .bearer
        }
    }
    
    
    
    // MARK: - default parameters
    
    public var baseURL: URL {
        return TaigaAPI.server
    }
    
    public var headers: [String : String]? {
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

extension TaigaAPI {
    static var server =  URL(string: "https://project.manuelselch.de/api/v1")!
}

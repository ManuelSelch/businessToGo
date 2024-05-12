import Foundation
import Moya

enum KimaiRequest {
    case getCustomers
    case getProjects
    case getActivities
    case getTimesheets(_ page: Int)
    
    case insertTimesheet(KimaiTimesheet)
    case updateTimesheet(KimaiTimesheet)
    
    
}
 
extension KimaiRequest: Moya.TargetType {
    var task: Moya.Task {
        switch self {
        case .getCustomers, .getProjects, .getActivities:
            return .requestPlain
        case .getTimesheets(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .insertTimesheet(_), .updateTimesheet(_):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    

    var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    
    var baseURL: URL {
        return KimaiRequest.server
    }
    
    var path: String {
        switch self {
        case .getCustomers:
            return "/customers"
        case .getProjects:
            return "/projects"
        case .getTimesheets, .insertTimesheet(_):
            return "/timesheets"
        case .updateTimesheet(let timesheet):
            return "/timesheets/\(timesheet.id)"
        case .getActivities:
            return "/activities"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCustomers, .getProjects, .getActivities, .getTimesheets(_):
            return .get
        case .insertTimesheet(_):
            return .post
        case .updateTimesheet(_):
            return .patch
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getProjects, .getCustomers, .getActivities:
            return [:]
        case .getTimesheets(let page):
            return [
                "page": page,
                "user": "all"
            ]
        case .insertTimesheet(let timesheet), .updateTimesheet(let timesheet):
            return [
                "project": timesheet.project,
                "activity": timesheet.activity,
                "begin": timesheet.begin,
                "end": timesheet.end as Any,
                "description": timesheet.description as Any
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    
    var validate: Bool {
        switch self {
        default:
            return true
        }
    }
}


extension KimaiRequest {
    static var server =  URL(string: "https://time.manuelselch.de/api")!
}

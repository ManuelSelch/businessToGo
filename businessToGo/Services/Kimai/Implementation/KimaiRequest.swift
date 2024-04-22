import Moya

enum KimaiRequest {
    case getCustomers
    
    case getProjects
    
    case getTimesheets
    case insertTimesheet(KimaiTimesheet)
    
    case getActivities
}
 
extension KimaiRequest: TargetType {
    var task: Moya.Task {
        switch self {
        case .getCustomers, .getProjects, .getTimesheets, .getActivities:
            return .requestPlain
        case .insertTimesheet(_):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    

    var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
    }
    
    var baseURL: URL {
        return URL(string: "https://time.manuelselch.de/api")!
    }
    
    var path: String {
        switch self {
        case .getCustomers:
            return "/customers"
        case .getProjects:
            return "/projects"
        case .getTimesheets, .insertTimesheet(_):
            return "/timesheets"
        case .getActivities:
            return "/activities"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCustomers, .getProjects, .getTimesheets, .getActivities:
            return .get
        case .insertTimesheet(_):
            return .post
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getCustomers, .getProjects, .getTimesheets, .getActivities:
            return [:]
        case .insertTimesheet(let timesheet):
            return [
                "project": timesheet.project,
                "activity": timesheet.activity,
                "begin": timesheet.begin
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

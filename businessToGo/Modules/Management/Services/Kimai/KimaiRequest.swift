import Foundation
import Moya

enum KimaiRequest {
    case getCustomers
    case insertCustomer(KimaiCustomer)
    case updateCustomer(KimaiCustomer)
    
    case getProjects
    case insertProject(KimaiProject)
    case updateProject(KimaiProject)
    
    case getActivities
    
    case getTimesheets(_ page: Int)
    case insertTimesheet(KimaiTimesheet)
    case updateTimesheet(KimaiTimesheet)
    case deleteTimesheet(Int)
    
    case getTeams
    
    
}
 
extension KimaiRequest: Moya.TargetType {
    var task: Moya.Task {
        switch self {
        case .getCustomers, .getProjects, .getActivities, .deleteTimesheet(_), .getTeams:
            return .requestPlain
        case .getTimesheets(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
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
        case .getCustomers, .insertCustomer(_):
            return "/customers"
        case .updateCustomer(let customer):
            return "/customers/\(customer.id)"
            
        case .getProjects, .insertProject(_):
            return "/projects"
        case .updateProject(let project):
            return "/projects/\(project.id)"
            
        case .getTimesheets, .insertTimesheet(_):
            return "/timesheets"
        case .updateTimesheet(let timesheet):
            return "/timesheets/\(timesheet.id)"
        case .deleteTimesheet(let id):
            return "/timesheets/\(id)"
            
        case .getActivities:
            return "/activities"
            
        case .getTeams:
            return "/teams"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCustomers, .getProjects, .getActivities, .getTimesheets(_), .getTeams:
            return .get
        case .insertTimesheet(_), .insertProject(_), .insertCustomer(_):
            return .post
        case .updateTimesheet(_), .updateProject(_), .updateCustomer(_):
            return .patch
        case .deleteTimesheet(_):
            return .delete
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getProjects, .getCustomers, .getActivities, .deleteTimesheet(_), .getTeams:
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
        case .insertProject(let project), .updateProject(let project):
            return [
                "name": project.name,
                "customer": project.customer,
                "visible": true
            ]
            
        case .insertCustomer(let customer):
            return [
                "name": customer.name,
                "number": customer.number as Any,
                "color": customer.color as Any,
                "country": "DE",
                "currency": "EUR",
                "timezone": "Europe/Berlin",
                "visible": true
            ]
        
        case .updateCustomer(let customer):
            return [
                "name": customer.name,
                "number": customer.number as Any,
                "color": customer.color as Any,
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

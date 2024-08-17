import Foundation
import Moya

import KimaiCore

public enum KimaiAPI {
    case getCustomers
    case insertCustomer(KimaiCustomerDTO)
    case updateCustomer(KimaiCustomerDTO)
    
    case getProjects
    case insertProject(KimaiProject)
    case updateProject(KimaiProject)
    
    case getActivities
    case insertActivity(KimaiActivity)
    case updateActivity(KimaiActivity)
    
    case getTimesheets(_ page: Int)
    case insertTimesheet(KimaiTimesheet)
    case updateTimesheet(KimaiTimesheet)
    case deleteTimesheet(Int)
    
    case getTeams
    case getUsers
    
}
 
extension KimaiAPI: Moya.TargetType {
    public var task: Moya.Task {
        switch self {
        case .getCustomers, .getProjects, .getActivities, .deleteTimesheet(_), .getTeams, .getUsers:
            return .requestPlain
        case .getTimesheets(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    

    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    
    public var baseURL: URL {
        return KimaiAPI.server
    }
    
    public var path: String {
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
            
        case .getActivities, .insertActivity(_):
            return "/activities"
        case .updateActivity(let activity):
            return "/activities/\(activity.id)"
            
        case .getTeams:
            return "/teams"
        
        case .getUsers:
            return "/users"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getCustomers, .getProjects, .getActivities, .getTimesheets(_), .getTeams, .getUsers:
            return .get
        case .insertTimesheet(_), .insertProject(_), .insertCustomer(_), .insertActivity(_):
            return .post
        case .updateTimesheet(_), .updateProject(_), .updateCustomer(_), .updateActivity(_):
            return .patch
        case .deleteTimesheet(_):
            return .delete
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getProjects, .getCustomers, .getActivities, .deleteTimesheet(_), .getTeams, .getUsers:
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
                "globalActivities": project.globalActivities,
                "visible": true,
            ]
            
        case .insertCustomer(let customer), .updateCustomer(let customer):
            return [
                "name": customer.name,
                "number": customer.number as Any,
                "color": customer.color as Any,
                "country": "DE",
                "currency": "EUR",
                "timezone": "Europe/Berlin",
                "visible": customer.visible
            ]
            
        case .insertActivity(let activity), .updateActivity(let activity):
            return [
                "name": activity.name,
                "color": activity.color as Any,
                "visible": activity.visible
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


extension KimaiAPI {
    static var server =  URL(string: "https://time.manuelselch.de/api")!
}

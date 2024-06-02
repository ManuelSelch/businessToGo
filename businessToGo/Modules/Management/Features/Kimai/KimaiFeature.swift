import Foundation
import OfflineSync
import Combine
import Redux

/// kimai backend storage
struct KimaiFeature: Reducer {
    
    @Dependency(\.kimai) var kimai
    
    struct State: Equatable, Codable {
        var selectedTeam: Int?
        
        var customers = RequestFeature<KimaiCustomer, KimaiRequest>.State()
        var projects = RequestFeature<KimaiProject, KimaiRequest>.State()
        var timesheets = RequestFeature<KimaiTimesheet, KimaiRequest>.State()
        var activities = RequestFeature<KimaiActivity, KimaiRequest>.State()
        var teams = RequestFeature<KimaiTeam, KimaiRequest>.State()
        var users = RequestFeature<KimaiUser, KimaiRequest>.State()
        
        
        var currentStep: Step? {
            if(customers.records.count == 0) {
                return .customer
            } else if(projects.records.count == 0) {
                return .project
            } else if(activities.records.count == 0) {
                return .activity
            } else if(timesheets.records.count == 0) {
                return .timesheet
            } else {
                return nil
            }
        }
        
        var steps: [Step] = Step.allCases
        
    }
    
    
    
    
    enum Action: Codable {
        case teamSelected(Int?)
        case customerTapped(Int)
        case customerEditTapped(KimaiCustomer)
        case customerSaveTapped(KimaiCustomer)
        
        case customers(RequestFeature<KimaiCustomer, KimaiRequest>.Action)
        case projects(RequestFeature<KimaiProject, KimaiRequest>.Action)
        case timesheets(RequestFeature<KimaiTimesheet, KimaiRequest>.Action)
        case activities(RequestFeature<KimaiActivity, KimaiRequest>.Action)
        case teams(RequestFeature<KimaiTeam, KimaiRequest>.Action)
        case users(RequestFeature<KimaiUser, KimaiRequest>.Action)
        
        // assistant
        case stepTapped
        case dashboardTapped
        
        case projectList(ProjectsListAction)
        case projectSheet(ProjectSheetAction)
        case projectDetail(ProjectDetailAction)
        case timesheetSheet(TimesheetSheetAction)
        
        case delegate(Delegate)
    }
    
    enum Delegate: Codable {
        case route(Route)
        case dismiss
    }
    
    enum Route: Hashable, Codable {
        case customersList
        case customerSheet(KimaiCustomer)
        
        case projectsList(_ customer: Int)
        case projectSheet(KimaiProject)
        case projectDetail(KimaiProject)
        
        case timesheetSheet(KimaiTimesheet)
    }
    
    enum Step: String, CaseIterable, Codable, Equatable {
        case customer = "Ersten Kunden anlegen"
        case project = "Erstes Projekt anlegen anlegen"
        case activity = "Erste Tätigkeit anlegen"
        case timesheet = "Esten Timesheet Eintrag anlegen"
        
        var index: Int { Step.allCases.firstIndex(of: self) ?? 0 }
    }
    
    enum ProjectsListAction: Codable {
        case projectTapped(Int)
        case projectEditTapped(KimaiProject)
    }
    
    enum ProjectSheetAction: Codable {
        case saveTapped(KimaiProject)
    }
    
    enum ProjectDetailAction: Codable {
        case deleteTapped(KimaiTimesheet)
        case editTapped(KimaiTimesheet)
    }
    
    enum TimesheetSheetAction: Codable {
        case saveTapped(KimaiTimesheet)
    }
    
    func sync() -> AnyPublisher<Action, Error> {
        return .merge([
            RequestFeature(service: kimai.customers).sync()
                .map { .customers($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: kimai.projects).sync()
                .map { .projects($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: kimai.timesheets).sync()
                .map { .timesheets($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: kimai.activities).sync()
                .map { .activities($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: kimai.teams).sync()
                .map { .teams($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: kimai.users).sync()
                .map { .users($0) }
                .eraseToAnyPublisher()
        ])
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
        case let .customerTapped(id):
            return .send(.delegate(.route(.projectsList(id))))
        case let .customerEditTapped(customer):
            return .send(.delegate(.route(.customerSheet(customer))))
        case let .customerSaveTapped(customer):
            if(customer.id == KimaiCustomer.new.id) {
                return .merge([
                    .send(.customers(.create(customer))),
                    .send(.delegate(.dismiss))
                ])
            } else {
                return .merge([
                    .send(.customers(.update(customer))),
                    .send(.delegate(.dismiss))
                ])
            }
           
        case .teamSelected(let team):
            state.selectedTeam = team
            return .none
            
        case let .customers(action):
            return RequestFeature(service: kimai.customers).reduce(into: &state.customers, action: action)
                .map { .customers($0) }
                .eraseToAnyPublisher()
            
        case let .projects(action):
            return RequestFeature(service: kimai.projects).reduce(into: &state.projects, action: action)
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
        case let .timesheets(action):
            return RequestFeature(service: kimai.timesheets).reduce(into: &state.timesheets, action: action)
                .map { .timesheets($0) }
                .eraseToAnyPublisher()
            
        case let .activities(action):
            return RequestFeature(service: kimai.activities).reduce(into: &state.activities, action: action)
                .map { .activities($0) }
                .eraseToAnyPublisher()
            
        case let .teams(action):
            return RequestFeature(service: kimai.teams).reduce(into: &state.teams, action: action)
                .map { .teams($0) }
                .eraseToAnyPublisher()
            
        case let .users(action):
            return RequestFeature(service: kimai.users).reduce(into: &state.users, action: action)
                .map { .users($0) }
                .eraseToAnyPublisher()
            
        case .stepTapped:
            switch(state.currentStep) {
            case .customer:
                return .none
            case .project:
                return .none
            case .activity:
                return .none
            case .timesheet:
                return .none
            default:
                return .none
            }
        
        case .dashboardTapped:
            return .send(.delegate(.route(.customersList)))
                
        case let .projectList(action):
            switch(action) {
            case let .projectTapped(id):
                if let project = state.projects.records.first(where: {$0.id == id}) {
                    return .send(.delegate(.route(.projectDetail(project))))
                }
            case let .projectEditTapped(project):
                return .send(.delegate(.route(.projectSheet(project))))
            }
        case let .projectSheet(action):
            switch(action) {
            case let .saveTapped(project):
                if(project.id == KimaiProject.new.id) {
                    return .send(.projects(.create(project)))
                } else {
                    return .send(.projects(.update(project)))
                }
            }
        case let .projectDetail(action):
            switch(action) {
            case let .deleteTapped(timesheet):
                return .send(.timesheets(.delete(timesheet)))
            case let .editTapped(timesheet):
                return .send(.delegate(.route(.timesheetSheet(timesheet))))
            }
        case let .timesheetSheet(action):
            switch(action) {
            case let .saveTapped(timesheet):
                if(timesheet.id == KimaiTeam.new.id) {
                    return .send(.timesheets(.create(timesheet)))
                } else {
                    return .send(.timesheets(.update(timesheet)))
                }
            }
            
        case .delegate:
            return .none
        
        }
        
        return .none
    }
    
    
}




import Foundation
import Combine

import KimaiCore

public extension KimaiFeature {
    func sync() -> AnyPublisher<Action, Error> {
        return .merge([
            self.kimai.customers.sync()
                .map { .synced(.customers($0)) }
                .eraseToAnyPublisher()
        ])
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
        case let .customerList(action):
            switch(action) {
            case let .tapped(id):
                return .send(.delegate(.route(.projectsList(id))))
            case let .editTapped(customer):
                return .send(.delegate(.route(.customerSheet(customer))))
            case let .saveTapped(customer):
                if(customer.id == KimaiCustomer.new.id) {
                    kimai.customers.create(customer)
                } else {
                    kimai.customers.update(customer)
                }
                state.customers = kimai.customers.get()
                return .send(.delegate(.dismiss))
                
            case .teamSelected(let team):
                state.selectedTeam = team
                return .none
            }
            
        case let .assistant(action):
            switch(action) {
            case .stepTapped:
                switch(state.currentStep) {
                case .customer:
                    return .send(.delegate(.route(.customerSheet(.new))))
                case .project:
                    return .send(.delegate(.route(.projectSheet(.new))))
                case .activity:
                    return .none
                case .timesheet:
                    return .none
                default:
                    return .none
                }
                
            case .dashboardTapped:
                if(state.currentStep == .none) {
                    return .send(.delegate(.route(.customersList)))
                }
            }
                
        case let .projectList(action):
            switch(action) {
            case let .projectTapped(id):
                if let project = state.projects.first(where: {$0.id == id}) {
                    return .send(.delegate(.route(.projectDetail(project))))
                }
            case let .projectEditTapped(project):
                return .send(.delegate(.route(.projectSheet(project))))
            }
        
        case let .projectSheet(action):
            switch(action) {
            case let .saveTapped(project):
                if(project.id == KimaiProject.new.id) {
                    kimai.projects.create(project)
                } else {
                    kimai.projects.update(project)
                }
                state.projects = kimai.projects.get()
                return .send(.delegate(.dismiss))
            }
        case let .projectDetail(action):
            switch(action) {
            case let .deleteTapped(timesheet):
                kimai.timesheets.delete(timesheet)
                state.timesheets = kimai.timesheets.get()
            case let .editTapped(timesheet):
                return .send(.delegate(.route(.timesheetSheet(timesheet))))
            }
        case let .timesheetSheet(action):
            switch(action) {
            case let .saveTapped(timesheet):
                if(timesheet.id == KimaiTeam.new.id) {
                    kimai.timesheets.create(timesheet)
                } else {
                    kimai.timesheets.update(timesheet)
                }
                state.timesheets = kimai.timesheets.get()
            }
            
        case let .synced(action):
            switch(action) {
            case let .customers(records):
                state.customers = records
            case let .projects(records):
                state.projects = records
            case let .activities(records):
                state.activities = records
            case let .teams(records):
                state.teams = records
            case let .users(records):
                state.users = records
            }
            
        case .delegate:
            return .none
        
        }
        
        return .none
    }
}

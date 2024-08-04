import Foundation
import Combine 

import KimaiCore

import Redux
import ReduxDebug

public extension KimaiFeature {
    
    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action){
        case let .customer(action):
            switch(action) {
            case let .save(customer):
                Logger.debug("save customer")
                if(customer.id == KimaiCustomer.new.id) {
                    Logger.debug("new customer")
                    kimai.customers.create(customer)
                } else {
                    Logger.debug("update customer")
                    kimai.customers.update(customer)
                }
                state.customers = kimai.customers.get()
                
            case .teamSelected(let team):
                state.selectedTeam = team
                return .none
            }
            
        case let .assistant(action):
            switch(action) {
            case .stepTapped:
                switch(state.currentStep) {
                case .customer:
                    // return .send(.delegate(.route(.customerSheet(.new))))
                    break
                case .project:
                    // return .send(.delegate(.route(.projectSheet(.new))))
                    break
                case .activity:
                    return .none
                case .timesheet:
                    return .none
                default:
                    return .none
                }
                
            case .dashboardTapped:
                if(state.currentStep == .none) {
                    // return .send(.delegate(.route(.customersList)))
                    break
                }
            }
                

        
        case let .project(action):
            switch(action) {
            case let .save(project):
                if(project.id == KimaiProject.new.id) {
                    kimai.projects.create(project)
                } else {
                    kimai.projects.update(project)
                }
                state.projects = kimai.projects.get()
            }
        case let .timesheet(action):
            switch(action) {
            case let .delete(timesheet):
                kimai.timesheets.delete(timesheet)
                state.timesheets = kimai.timesheets.get()
            case let .save(timesheet):
                if(timesheet.id == KimaiTeam.new.id) {
                    kimai.timesheets.create(timesheet)
                } else {
                    kimai.timesheets.update(timesheet)
                }
                state.timesheets = kimai.timesheets.get()
            }
            
            
        case .sync:
            state.customers = kimai.customers.get()
            state.projects = kimai.projects.get()
            state.activities = kimai.activities.get()
            state.teams = kimai.teams.get()
            state.users = kimai.users.get()
            state.timesheets = kimai.timesheets.get()
            
            return .run { send in
                do {
                    let customers = try await kimai.customers.sync()
                    let projects = try await kimai.projects.sync()
                    let activities = try await kimai.activities.sync()
                    let teams = try await kimai.teams.sync()
                    let users = try await kimai.users.sync()
                    let timesheets = try await kimai.timesheets.sync()
                    
                    send(.success(.synced(
                        customers, projects, activities, teams, users, timesheets
                    )))
                } catch {}
                
            }
            
        case let .synced(customers, projects, activities, teams, users, timesheets):
            state.customers = customers
            state.projects = projects
            state.activities = activities
            state.teams = teams
            state.users = users
            state.timesheets = timesheets
        
        }
        
        return .none
    }
}

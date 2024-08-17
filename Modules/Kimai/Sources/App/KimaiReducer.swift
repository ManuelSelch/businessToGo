import Foundation
import Combine 
import Moya
import OfflineSyncServices
import OfflineSyncCore

import KimaiCore

import Redux
import ReduxDebug
import KimaiServices

public extension KimaiFeature {
    func fetchOffline(_ state: inout State) {
        state.customers = kimai.customers.getCustomers().filter({$0.visible})
        state.projects = kimai.projects.get().filter({$0.visible})
        state.activities = kimai.activities.get().filter({$0.visible})
        state.teams = kimai.customers.getTeams()
        state.users = kimai.users.get()
        state.timesheets = kimai.timesheets.get()
        
        fetchChanges(&state)
    }
    
    func fetchChanges(_ state: inout State) {
        state.customerChanges = kimai.customers.getCustomerChanges()
        state.projectChanges = kimai.projects.getChanges()
        state.activityChanges = kimai.activities.getChanges()
        state.timesheetChanges = kimai.timesheets.getChanges()
    }
    
    func delete<Table: KimaiTableProtocol>(_ record: Table, changes: [DatabaseChange], service: RecordService<Table>) -> [Table] {
        var record = record

        if let change = changes.get(record.id), change.type == .insert {
            service.delete(record.id)
        } else {
            record.visible = false
            service.update(record)
        }
        
        return service.get().filter({$0.visible})
    }
    
    func delete(_ record: KimaiCustomer, changes: [DatabaseChange], service: KimaiCustomerService) -> [KimaiCustomer] {
        var record = record

        if let change = changes.get(record.id), change.type == .insert {
            service.deleteCustomer(record.id)
        } else {
            record.visible = false
            service.updateCustomer(record)
        }
        
        return service.getCustomers().filter({$0.visible})
    }
    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action){
        case let .customer(action):
            switch(action) {
            case .teamSelected(let team):
                state.selectedTeam = team
                
            case let .save(customer):
                Logger.debug("save customer")
                if(customer.id == KimaiCustomer.new.id) {
                    Logger.debug("new customer")
                    kimai.customers.createCustomer(customer)
                } else {
                    Logger.debug("update customer")
                    kimai.customers.updateCustomer(customer)
                }
                state.customers = kimai.customers.getCustomers().filter({$0.visible})
            
            case let .delete(customer):
                guard(state.projects.filter({$0.customer == customer.id}).count == 0) else {
                    return .send(.delegate(.popup(.customerDeleteNotAllowed(customer))))
                }
                
                return .send(.delegate(.popup(.customerDeleteConfirmation(customer))))
                
            case let .deleteConfirmed(customer):
                state.customers = delete(customer, changes: state.customerChanges, service: kimai.customers)
                return .send(.delegate(.dismissPopup))
            }
                

        
        case let .project(action):
            switch(action) {
            case let .save(project):
                if(project.id == KimaiProject.new.id) {
                    kimai.projects.create(project)
                } else {
                    kimai.projects.update(project)
                }
                state.projects = kimai.projects.get().filter({$0.visible})
            case let .delete(project):
                guard(state.activities.filter({$0.project == project.id}).count == 0) else {
                    return .send(.delegate(.popup(.projectDeleteNotAllowed(project))))
                }
                return .send(.delegate(.popup(.projectDeleteConfirmation(project))))
            case let .deleteConfirmed(project):
                state.projects = delete(project, changes: state.projectChanges, service: kimai.projects)
                return .send(.delegate(.dismissPopup))
            }
            
        case let .activity(action):
            switch(action) {
            case let .save(activity):
                if(activity.id == KimaiActivity.new.id) {
                    kimai.activities.create(activity)
                } else {
                    kimai.activities.update(activity)
                }
                state.activities = kimai.activities.get().filter({$0.visible})
            case let .delete(activity):
                return .send(.delegate(.popup(.activityDeleteConfirmation(activity))))
            case let .deleteConfirmed(activity):
                state.activities = delete(activity, changes: state.activityChanges, service: kimai.activities)
                return .send(.delegate(.dismissPopup))
            }
            
        case let .timesheet(action):
            switch(action) {
            case let .save(timesheet):
                if(timesheet.id == KimaiTeam.new.id) {
                    kimai.timesheets.create(timesheet)
                } else {
                    kimai.timesheets.update(timesheet)
                }
                state.timesheets = kimai.timesheets.get()
            case let .delete(timesheet):
                return .send(.delegate(.popup(.timesheetDeleteConfirmation(timesheet))))
            case let .deleteConfirmed(timesheet):
                kimai.timesheets.delete(timesheet.id)
                state.timesheets = kimai.timesheets.get()
                return .send(.delegate(.dismissPopup))
            }
            
            
        case .sync:
            fetchOffline(&state)
            
            return .run { send in
                do {
                    let (customers, teams) = try await kimai.customers.sync()
                    let projects = try await kimai.projects.sync()
                    let activities = try await kimai.activities.sync()
                    let users = try await kimai.users.sync()
                    let timesheets = try await kimai.timesheets.sync()
                    
                    send(.success(.synced(
                        customers, projects, activities, teams, users, timesheets
                    )))
                } catch {
                    Logger.error("failed syncing kimai")
                }
                
            }
            
        case let .synced(customers, projects, activities, teams, users, timesheets):
            state.customers = customers.filter({$0.visible})
            state.projects = projects.filter({$0.visible})
            state.activities = activities.filter({$0.visible})
            state.teams = teams
            state.users = users
            state.timesheets = timesheets
            
            fetchChanges(&state)
            
        case .delegate: return .none
        }
        
        return .none
    }
}

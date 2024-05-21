import Foundation
import OfflineSync
import Redux
import SwiftUI

struct KimaiModule {
    struct State: Equatable, Codable {
        var selectedTeam: Int?
        
        var customers: [KimaiCustomer] = []
        var projects: [KimaiProject] = []
        var timesheets: [KimaiTimesheet] = []
        var activities: [KimaiActivity] = []
        var teams: [KimaiTeam] = []
        var users: [KimaiUser] = []
        
        var customerTracks: [DatabaseChange] = []
        var projectTracks: [DatabaseChange] = []
        var timesheetTracks: [DatabaseChange] = []
        var activityTracks: [DatabaseChange] = []
        var teamTracks: [DatabaseChange] = []
        var userTracks: [DatabaseChange] = []
    }
    
    enum Action {
        case sync
        
        case selectTeam(Int?)
        
        case customers(RequestAction<KimaiCustomer>)
        case projects(RequestAction<KimaiProject>)
        case timesheets(RequestAction<KimaiTimesheet>)
        case activities(RequestAction<KimaiActivity>)
        case teams(RequestAction<KimaiTeam>)
        case users(RequestAction<KimaiUser>)
    }
    
    struct Dependency {
        var kimai: KimaiService
        var track: TrackTable
    }
}




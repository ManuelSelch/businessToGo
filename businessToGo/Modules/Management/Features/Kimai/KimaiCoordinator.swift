import Foundation
import ComposableArchitecture

@Reducer(state: .equatable)
enum KimaiCoordinator {
    case customersList(KimaiCustomersListFeature)
    case customerSheet(KimaiCustomerSheetFeature)
    
    case projectsList(KimaiProjectsListFeature)
    case projectSheet(KimaiProjectSheetFeature)
    case projectDetail(KimaiProjectDetailFeature)
    
    case timesheetsList(KimaiTimesheetsListFeature)
    case timesheetSheet(KimaiTimesheetSheetFeature)
    
    init() {
        self = .customersList(.init())
    }
}


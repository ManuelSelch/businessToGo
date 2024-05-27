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

struct KimaiCoordinator02 {
    struct State {
        @Shared var kimai: KimaiModule.State
        @Shared var taiga: TaigaModule.State
    }
    
    enum Action {
        case test
    }
}

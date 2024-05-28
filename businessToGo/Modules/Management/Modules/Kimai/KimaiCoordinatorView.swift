import SwiftUI
import ComposableArchitecture

struct KimaiCoordinatorView: View {
    let store: StoreOf<KimaiCoordinator>
    
    var body: some View {
        switch(store.state){
        case .customersList:
            if let store = store.scope(state: \.customersList, action: \.customersList) {
                KimaiCustomersListView(store: store)
            }
        case .customerSheet:
            if let store = store.scope(state: \.customerSheet, action: \.customerSheet) {
                KimaiCustomerSheet(store: store)
            }
            
            
        case .projectsList:
            if let store = store.scope(state: \.projectsList, action: \.projectsList) {
                KimaiProjectsListView(store: store)
            }
        case .projectSheet:
            if let store = store.scope(state: \.projectSheet, action: \.projectSheet) {
                KimaiProjectSheet(store: store)
            }
        case .projectDetail:
            if let store = store.scope(state: \.projectDetail, action: \.projectDetail) {
                KimaiProjectDetailsView(store: store)
            }
        
            
        case .timesheetsList:
            if let store = store.scope(state: \.timesheetsList, action: \.timesheetsList) {
                KimaiTimesheetsListContainer(store: store)
            }
        case .timesheetSheet:
            if let store = store.scope(state: \.timesheetSheet, action: \.timesheetSheet) {
                KimaiTimesheetSheet(store: store)
            }
        }
    }
}

import SwiftUI
import OfflineSync
import ComposableArchitecture

struct KimaiTimesheetsListContainer: View {
    let store: StoreOf<KimaiTimesheetsListFeature>
    
    var body: some View {
        KimaiTimesheetsListView(
            projects: [store.project],
            timesheets: store.timesheets.records.filter { $0.project == store.project.id },
            timesheetChanges: store.timesheets.changes,
            activities: store.activities,
            deleteTapped: { store.send(.deleteTapped($0)) },
            editTapped: { store.send(.editTapped($0)) }
        )
    }
}


#Preview {
    KimaiTimesheetsListContainer(
        store: .init(initialState: .init(
            project: .sample,
            timesheets: Shared(RequestModule.State(records: [KimaiTimesheet.sample])),
            activities: Shared([KimaiActivity.sample])
        )) {
            KimaiTimesheetsListFeature()
        }
    )
}

import Foundation
import ComposableArchitecture

@Reducer
struct KimaiProjectSheetFeature {
    @ObservableState
    struct State: Equatable {
        var project: KimaiProject
        @Shared var customers: [KimaiCustomer]
    }
    
    enum Action {
        case saveTapped(KimaiProject)
        case delegate(Delegate)
    }
    
    enum Delegate {
        case dismiss
        case create(KimaiProject)
        case update(KimaiProject)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case let .saveTapped(project):
            return .run { send in
                if(project.id == KimaiProject.new.id) {
                    await send(.delegate(.create(project)))
                } else {
                    await send(.delegate(.update(project)))
                }
                await send(.delegate(.dismiss))
            }
        case .delegate:
            return .none
        }
    }
}

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct IntroModule {
    @ObservableState
    struct State: Codable, Equatable {
        var pages: [IntroPage] = [
            .init(name: "Willkommen", description: "Die App wurde nun neu strukturiert in 'Projekte' und 'Reports'", image: "reports", tag: 0),
            .init(name: "Reports", description: "Im 'Reports' Tab lassen sich die Stunden nach Projekt sowie nach Datum filtern. Wechsle von der Wochenansicht in die Tagesansicht um durch die einzelnen Tage zu scrollen", image: "days", tag: 1),
            .init(name: "Projekte", description: "Im 'Projekte' Tab siehtst du alle Projekte und kannst diese nach Team und Kunde filtern. Aktiviere noch die Projektmanagement-Integration in den Einstellungen um weitere Tools wie das Kanban Board zu nutzen", image: "projects", tag: 2)
        ]
    }
    
    enum Action {
        case load
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showIntro
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch(action){
        case .load:
            let show = UserDefault.isIntro
            UserDefault.isIntro = false
            
            if(show) {
                return .send(.delegate(.showIntro))
            } else {
                return .none
            }
            
        case .delegate:
            return .none
        }
        
    }
    
}

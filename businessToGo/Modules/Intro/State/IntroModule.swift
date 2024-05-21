import Foundation
import Redux
import Combine

struct IntroModule: Reducer {
    struct State: Codable, Equatable {
        var pages: [IntroPage] = [
            .init(name: "Willkommen", description: "Die App wurde nun neu strukturiert in 'Projekte' und 'Reports'", image: "reports", tag: 0),
            .init(name: "Reports", description: "Im 'Reports' Tab lassen sich die Stunden nach Projekt sowie nach Datum filtern. Wechsle von der Wochenansicht in die Tagesansicht um durch die einzelnen Tage zu scrollen", image: "days", tag: 1),
            .init(name: "Projekte", description: "Im 'Projekte' Tab siehtst du alle Projekte und kannst diese nach Team und Kunde filtern. Aktiviere noch die Projektmanagement-Integration in den Einstellungen um weitere Tools wie das Kanban Board zu nutzen", image: "projects", tag: 2)
        ]
        var isVisible = false
    }
    
    enum Action {
        case load
    }
    struct Dependency {}
    
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>  {
        switch(action){
        case .load:
            state.isVisible = UserDefault.isIntro
            UserDefault.isIntro = false
        }
        return Empty().eraseToAnyPublisher()
    }
    
}

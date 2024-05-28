import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct IntroModule {
    @ObservableState
    struct State: Codable, Equatable {
        var pages: [IntroPage] = [
            .init(
                name: "Willkommen",
                description: "Erleben Sie ein effektives Zeit- und Projektmanagement in einer einzigen App",
                image: "reports",
                tag: 0
            ),
            .init(
                name: "Timemanagement",
                description: "Planen und erfassen Sie Ihre Zeiten für unterschiedliche Kunden, Projekte, Aufgaben und Mitarbeiter",
                image: "reports",
                tag: 1
            ),
            .init(
                name: "Projektmanagement",
                description: "Organisieren und verwalten Sie Ihre Projekte und Aufgaben über Agiles Projektmanagement oder Kanban-Boards",
                image: "projects",
                tag: 2
            ),
            .init(
                name: "Berichte",
                description: "Filtern Sie Stunden nach Projekt, Tätigkeit, Benutzer oder Datum",
                image: "days",
                tag: 3
            ),
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

import Foundation
import Combine
import Redux


struct IntroFeature: Reducer {
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
    
    enum Action: Codable {
        case load
        case delegate(Delegate)
    }
    
    enum Delegate: Codable {
        case showIntro
    }
    
    struct Dependency {
        
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
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
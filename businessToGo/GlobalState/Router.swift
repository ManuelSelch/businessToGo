import SwiftUI

protocol Router: ObservableObject {
    associatedtype Route
    
    var routes: [Route] {get set}
}

extension Router {
    func navigate(_ route: Route){
        routes.append(route)
    }
    
    func back(){
        routes.removeLast()
    }
}

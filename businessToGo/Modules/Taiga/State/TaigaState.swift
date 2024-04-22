import Foundation
import SwiftUI
 
enum TaigaScreen: Equatable {
    case projects
    case backlog(TaigaProject)
    case kanban(TaigaProject)
}

struct TaigaState: Equatable {
    var scene: TaigaScreen
    
    var projectImages: [Int: UIImage]
}


extension TaigaState {
    init(){
        scene = .projects
        projectImages = [:]
    }
}

import Foundation
import SwiftUI
 
enum TaigaScreen: Equatable, Hashable {
    case projects
    case project(Int)
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

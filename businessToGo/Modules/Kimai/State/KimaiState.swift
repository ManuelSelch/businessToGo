import Foundation

enum KimaiScreen: Equatable { 
    case customers
    case chart
    case customer(Int)
    case project(Int)
    case timesheet(Int)
}

struct KimaiState: Equatable {
    var scene: KimaiScreen
}

extension KimaiState {
    init() {
        scene = .customers
    }
}

import Foundation

enum KimaiRoute: Equatable, Hashable {
    case customers
    case chart
    case customer(Int)
    case project(Int)
    case timesheet(Int)
}

struct KimaiState: Equatable {
    var scene: KimaiRoute
}

extension KimaiState {
    init() {
        scene = .customers
    }
}


import Foundation
import ComposableArchitecture

@Reducer
enum TaigaCoordinator {
    case project(TaigaProjectFeature)
}

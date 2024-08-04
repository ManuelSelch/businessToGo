import Redux

public extension IntegrationFeature {
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        return .none
    }
}

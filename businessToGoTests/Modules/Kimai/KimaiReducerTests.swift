import XCTest

@testable import businessToGo

final class KimaiReducerTests: XCTestCase {
    var store: Store<KimaiState, KimaiAction>!
    
    override func setUp() {
        Env = .mock
        store = Store<KimaiState, KimaiAction>(initialState: KimaiState(), reducer: KimaiState.reduce)
    }
    
    func testNavigate() throws {
        store.send(.navigate(.customer(3)))
        XCTAssertEqual(KimaiScreen.customer(3), store.state.scene)
    }
}

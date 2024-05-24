import XCTest
import Redux

@testable import businessToGo

final class ManagementReducerTests: XCTestCase {
    var store: StoreOf<ManagementModule>!
    
    override func setUp() {
        store = .init(
            initialState: .init(),
            reducer: ManagementModule.reduce,
            dependencies: .mock
        )
    }
    
    
    func testConnectIntegrations() {
        store.send(.connect(2, 3))
        XCTAssertEqual(store.state.integrations, [.init(2, 3)])
    }
    
}

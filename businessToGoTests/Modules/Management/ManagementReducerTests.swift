import XCTest
import ComposableArchitecture

@testable import businessToGo

final class ManagementReducerTests: XCTestCase {
    var store: TestStoreOf<ManagementModule>!
    
    override func setUp() {
        store = .init(initialState: .init()) {
            ManagementModule()
        }
    }
    
    
    func testConnectIntegrations() async {
        await store.send(.connect(2, 3)) {
            $0.integrations =  [.init(2, 3)]
        }
    }
    
}

import XCTest
import Redux
import ReduxTestStore

import KimaiApp
@testable import KimaiCore

final class TestKimaiReducer: XCTestCase {
    var store: TestStoreOf<KimaiFeature>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: KimaiFeature())
        
    }
    
    override func tearDown() async throws {
        await store.finish()
    }

    func testTeamSelected() async {
        var customer = KimaiCustomer.new
        customer.id = 1
        
        
        store.send(.customer(.save(.new)))
        await store.receive(.customer(.save(.new)), { state in
            state.customers = [customer]
        })
    }

}

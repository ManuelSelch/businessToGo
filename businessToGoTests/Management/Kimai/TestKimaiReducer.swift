import XCTest
import Redux
import ReduxTestStore

@testable import KimaiApp

final class TestKimaiReducer: XCTestCase {
    var store: TestStoreOf<KimaiFeature>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: KimaiFeature())
    }

    func testTeamSelected() {
        
    }

}

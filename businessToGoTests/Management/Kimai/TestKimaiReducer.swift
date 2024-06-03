import XCTest
import Redux
@testable import businessToGo

final class TestKimaiReducer: XCTestCase {
    var store: TestStoreOf<KimaiFeature>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: KimaiFeature())
    }

    func testTeamSelected() {
        store.send(.teamSelected(2)) {
            $0.selectedTeam = 2
        }
    }

}

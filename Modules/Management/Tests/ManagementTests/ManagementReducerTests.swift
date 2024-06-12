import XCTest
import ReduxTestStore

import KimaiCore
import ManagementCore

@testable import Redux
@testable import ManagementApp

final class ManagementTests: XCTestCase {
    var store: TestStoreOf<ManagementFeature>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: ManagementFeature())
    }
    
    func testPlayTapped() {
        store.send(.intern(.playTapped(KimaiTimesheet.sample))) {
            $0.router.sheet = .kimai(.timesheetSheet(KimaiTimesheet.sample))
        }
    }
    
    func testConnect() {
        store.send(.intern(.connect(1, 1))) {
            $0.integrations = [Integration(1, 1)]
        }
    }
    
    
}

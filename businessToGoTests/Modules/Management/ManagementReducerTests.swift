import XCTest
import Redux

@testable import businessToGo

final class ManagementReducerTests: XCTestCase {
    var store: StoreOf<ManagementModule>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: ManagementModule.reduce, dependencies: .mock)
    }
    
    func testNavigate() throws {
        
        XCTAssertEqual(true, false)
    }
}

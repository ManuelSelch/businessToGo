import XCTest
import Redux

@testable import businessToGo

final class ReportReducerTests: XCTestCase {
    var store: StoreOf<ReportModule>!
    
    override func setUp() {
        store = .init(
            initialState: .init(),
            reducer: ReportModule.reduce,
            dependencies: .init()
        )
    }
    
    func testSelectDate() {
        let date = Date.today.addDays(5)
        store.send(.selectDate(date))
        XCTAssertEqual(store.state.selectedDate, date)
    }
    
    func testSelectProject() {
        let project = 5
        store.send(.selectProject(5))
        XCTAssertEqual(store.state.selectedProject, project)
    }
}

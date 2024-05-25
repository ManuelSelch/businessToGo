import XCTest
import ComposableArchitecture

@testable import businessToGo

final class ReportReducerTests: XCTestCase {
    var store: TestStoreOf<ReportModule>!
    
    override func setUp() {
        store = .init(initialState: .init()) {
            ReportModule()
        }
    }
    
    func testSelectDate() async {
        let date = Date.today.addDays(5)
        await store.send(.selectDate(date)) {
            $0.selectedDate = date
        }
    }
    
    func testSelectProject() async {
        let project = 5
        await store.send(.selectProject(5)) {
            $0.selectedProject = project
        }
    }
}

import XCTest
import Combine
import TestableCombinePublishers
import OHHTTPStubs
import OHHTTPStubsSwift
import Moya

import ComposableArchitecture
import OfflineSync

@testable import businessToGo

final class KimaiServiceTests: XCTestCase {
    
    var store: StoreOf<ManagementModule>!
    
    @Dependency(\.kimai) var kimai
    
    override func setUp() {
        store = .init(initialState: .init()) {
            ManagementModule()
        }
    }

    func testLogin() async throws {
        let success = try await kimai.login(
            AccountData("username", "password", "https://time.dev.manuelselch.de")
        )
        XCTAssertEqual(true, success)
    }
    
    func testGetRemoteCustomers() async throws {
        let request = try await kimai.customers.fetch()

        XCTAssertEqual(.init(), request.response[0])
            
    }
    
    func testGetLocalCustomers() async {
        let c = KimaiCustomer(id: 1, name: "LocalCustomer", number: "1", teams: [])
        kimai.customers.create(c)
        
        let result = kimai.customers.get()
            
        XCTAssertEqual([c], result)
    }

}

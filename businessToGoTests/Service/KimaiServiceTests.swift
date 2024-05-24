import XCTest
import Combine
import TestableCombinePublishers
import OHHTTPStubs
import OHHTTPStubsSwift
import Moya

import Redux
import OfflineSync

@testable import businessToGo

final class KimaiServiceTests: XCTestCase {
    
    var store: StoreOf<ManagementModule>!
    
    override func setUp() {
        store = .init(
            initialState: .init(),
            reducer: ManagementModule.reduce,
            dependencies: .mock
        )
        
        stub(
            condition: isHost("time.dev.manuelselch.de")
        ){ _ in
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("kimaiCustomers.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
    }

    func testLogin() async throws {
        let success = try await store.dependencies.kimai.login(
            AccountData("username", "password", "https://time.dev.manuelselch.de")
        )
        XCTAssertEqual(true, success)
    }
    
    func testGetRemoteCustomers() async throws {
        let request = try await store.dependencies.kimai.customers.fetch()

        XCTAssertEqual("string", request.response[0].name)
            
    }
    
    func testGetLocalCustomers() async {
        let c = KimaiCustomer(id: 1, name: "LocalCustomer", number: "1", teams: [])
        store.dependencies.kimai.customers.create(c)
        
        let result = store.dependencies.kimai.customers.get()
            
        XCTAssertEqual([c], result)
    }

}

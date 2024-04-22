import XCTest
import Combine
import TestableCombinePublishers
import OHHTTPStubs
import Moya

@testable import businessToGo

final class KimaiServiceTests: XCTestCase {

    override func setUp() {
        stub(
            condition: isHost("time.manuelselch.de")
        ){ _ in
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("kimaiCustomers.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
    }

    func testLogin() async {
        Env.kimai.login("username", "password")
            .expect(true)
            .expectSuccess()
            .waitForExpectations(timeout: 3)
    }
    
    func testGetRemoteCustomers() async {
        Env.kimai.customers.fetch()
            .expect(checkCustomers)
            .waitForExpectations(timeout: 3)
    }
    
    func testGetLocalCustomers() async {
        let c = KimaiCustomer(id: 1, name: "LocalCustomer", number: "1")
        Env.kimai.customers.add(c)
        
        Env.kimai.customers.get()
            .expect([c])
            .waitForExpectations(timeout: 3)
    }
    
    func testSyncCustomers() async {
        let remote = [
            KimaiCustomer(id: 100, name: "Sync", number: "100")
        ]
        let change = DatabaseChange(id: 0, type: .insert, recordID: 0, tableName: "", timestamp: "")
        
        Env.kimai.customers.sync([])
            .collect()
            .expect([change])
            .waitForExpectations(timeout: 3)
    }
    
    func checkCustomers(_ customers: [KimaiCustomer]){
        XCTAssertEqual("string", customers[0].name)
    }


}

import XCTest
import ReduxTestStore

@testable import OfflineSync
@testable import KimaiApp

import KimaiCore

final class KimaiReducerTests: XCTestCase {
    var store: TestStoreOf<KimaiFeature>!
    
    override func setUp() {
        store = .init(initialState: .init(), reducer: KimaiFeature())
    }
    
    override func tearDown() async throws {
        await store.finish()
    }
    
    func testCustomerTapped() async {
        store.send(.assistant(.dashboardTapped)) { _ in }
        await store.receive(.delegate(.route(.customersList))) { _ in }
    }
    
    func testCustomerEditTapped() async {
        store.send(.customerList(.editTapped(.sample))) { _ in }
        await store.receive(.delegate(.route(.customerSheet(.sample)))) { _ in }
    }
    
    func testCustomerSaveTapped() async {
        store.send(.customerList(.saveTapped(.new))) { _ in }
        var customer = KimaiCustomer.new
        customer.id = 1
        
        await store.receive([
            //.customers(.create(.new)),
            .delegate(.dismiss)
        ]) {
            $0.customers = [customer]
        }
        
        customer.name = "update"
        store.send(.customerList(.saveTapped(customer))) { _ in }
        await store.receive([
            // .customers(.update(customer)),
            .delegate(.dismiss)
        ]) {
            $0.customers = [customer]
        }
    }
    
    func testTeamSelected() {
        store.send(.customerList(.teamSelected(5))) {
            $0.selectedTeam = 5
        }
    }
    
    func testStepTapped() async {
        // step 1: create customer
        store.send(.assistant(.stepTapped)) { _ in }
        await store.receive(.delegate(.route(.customerSheet(.new)))) { _ in }
        
        // still step 1
        store.send(.assistant(.stepTapped)) { _ in }
        await store.receive(.delegate(.route(.customerSheet(.new)))) { _ in }
        
        // create customer
        await testCustomerSaveTapped()
        
        // step 2: create project
        store.send(.assistant(.stepTapped)) { _ in }
        await store.receive(.delegate(.route(.projectSheet(.new)))) { _ in }
        
    }
    
    func testDashboardTapped() async {
        store.send(.assistant(.dashboardTapped)) { _ in }
        
        await testStepTapped()
        
        store.send(.assistant(.dashboardTapped)) { _ in }
        await store.receive(.delegate(.route(.customersList))) { _ in }
    }
   

}

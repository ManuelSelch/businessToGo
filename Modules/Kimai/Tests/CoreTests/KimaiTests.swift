import XCTest
import ReduxTestStore

import KimaiApp
import KimaiCore

final class KimaiTests: XCTestCase {
    var store: TestStoreOf<KimaiFeature>!
    
    override func setUp() {
        store = .init(
            initialState: .init(),
            reducer: KimaiFeature()
        )
    }
    
    override func tearDown() async throws {
        await store.finish()
    }
    
    func testCustomerTeamSelected() {
        store.send(.customer(.teamSelected(1))) {
            $0.selectedTeam = 1
        }
        
        store.send(.customer(.teamSelected(5))) {
            $0.selectedTeam = 5
        }
    }
    
    func testCustomerSave() {
        // create record
        var customer = KimaiCustomer.new
        customer.id = 1
        store.send(.customer(.save(.new))) {
            $0.customers = [customer]
        }
        
        // update record
        var updatedCustomer = customer
        updatedCustomer.name = "My Customer"
        store.send(.customer(.save(updatedCustomer))) {
            $0.customers = [updatedCustomer]
        }
    }
    
    func testCustomerDelete() async {
        // create record
        var customer = KimaiCustomer.new
        customer.id = 1
        store.send(.customer(.save(.new))) {
            $0.customers = [customer]
        }
        
        store.send(.customer(.delete(customer))) { state in }
        
        await store.receive(.delegate(.popup(.customerDeleteConfirmation(customer))), {
            state in
        })
        
        store.send(.customer(.deleteConfirmed(customer))) {
            $0.customers = []
        }
        
        await store.receive(.delegate(.dismissPopup), {
            state in
        })
    }
}

import XCTest
import Redux

@testable import businessToGo

final class LoginReducerTests: XCTestCase {
    var store: StoreOf<LoginModule>!
    
    override func setUp() {
        store = .init(
            initialState: .init(),
            reducer: LoginModule.reduce,
            dependencies: .mock
        )
    }

   
    func testNavigate() {
        XCTAssertEqual(store.state.scene, .accounts)
        
        store.send(.navigate(.account(.demo)))
        XCTAssertEqual(store.state.scene, .account(.demo))
    }
    
    func testLogin() throws {
        store.send(.login(.demo))
        // load from keychain -> account should still be correct
        store.send(.loadAccounts)
        XCTAssertEqual(store.state.current, .demo)
    }
    
    func testLogout() throws {
        store.send(.login(.demo))
        store.send(.logout)
        // load from keychain -> user should still be logged out
        store.send(.loadAccounts)
        XCTAssertEqual(store.state.scene, .accounts)
        XCTAssertEqual(store.state.current, nil)
    }
    
    func testSaveLoadReset() {
        XCTAssertEqual(store.state.accounts, [])
        
        let account = Account(id: 1, name: "MyAccount")
        store.send(.saveAccount(account))
        store.send(.loadAccounts)
        XCTAssertEqual(store.state.accounts, [account])
        
        store.send(.reset)
        XCTAssertEqual(store.state.accounts, [])
        store.send(.loadAccounts)
        XCTAssertEqual(store.state.accounts, [.demo])
    }
    
    
}

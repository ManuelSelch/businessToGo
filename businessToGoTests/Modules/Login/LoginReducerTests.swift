import XCTest
import ComposableArchitecture

@testable import businessToGo

final class LoginReducerTests: XCTestCase {
    var store: TestStoreOf<LoginModule>!
    
    override func setUp() {
        store = .init(initialState: .init()) {
            LoginModule()
        } withDependencies: {
            $0.keychain = .mock
        }
    }

   
    func testNavigate() async {
        await store.send(.navigate(.account(.demo))) {
            $0.scene = .account(.demo)
        }
    }
    
    func testLogin() async throws {
        await store.send(.login(.demo)) {
            $0.current = .demo
        }
    }
    
    func testLogout() async throws {
        await store.send(.login(.demo)) {
            $0.current = .demo
        }
        await store.receive(/LoginModule.Action.delegate(.showHome))
        await store.receive(\.saveAccount) {
            $0.scene = .account(.demo)
        }
        await store.receive(/LoginModule.Action.delegate(.syncKimai))
        
        await store.send(.logout) {
            $0.current = nil
            $0.scene = .accounts
        }
    }
    
    func testSaveLoadReset() async {
        let account = Account(id: 1, name: "MyAccount")
        await store.send(.saveAccount(account)) {
            $0.scene = .account(account)
        }
        
        await store.send(.loadAccounts) {
            $0.accounts = [account]
        }
        
        await store.send(.reset) {
            $0.accounts = []
        }
        
        await store.send(.loadAccounts) {
            $0.accounts = [.demo]
        }
    }
    
    
}

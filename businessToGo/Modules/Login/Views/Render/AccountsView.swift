import SwiftUI
import Redux

struct AccountsView: View {
    @ObservedObject var store: Store<LoginState, LoginAction, AppDependency>
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.createAccount)
                }){
                    Image(systemName: "plus")
                        .padding()
                        .font(.system(size: 20))
                }
                Spacer()
            }
            List {
                ForEach(store.state.accounts, id: \.identifier){ account in
                   
                    HStack {
                        VStack(alignment: .leading) {
                            Text(account.name)
                                .bold()
                                .foregroundStyle(Color.theme)
                            
                            if let kimai = account.kimai {
                                Text("Kimai: \(kimai.server)")
                                    .font(.footnote)
                                
                                Text(kimai.username)
                                    .font(.footnote)
                            }
                            Text("")
                            if let taiga = account.taiga {
                                Text("Taiga: \(taiga.server)")
                                    .font(.footnote)
                                
                                Text(taiga.username)
                                    .font(.footnote)
                            }
                        }
                        Spacer()
                        Button(action: {
                            store.send(.login(account))
                        }){
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20))
                                .padding()
                                .tint(.theme)
                                
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            store.send(.deleteAccount(account))
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .tint(.red)
                        
                        Button(role: .cancel) {
                            store.send(.navigate(.account(account)))
                        } label: {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                        .tint(.gray)
                    }
                }
                
            }
            
            Spacer()
            
            Button(action: {
                store.send(.reset)
            }){
                Text("Reset")
                    .foregroundStyle(Color.red)
            }
        }
        .onAppear {
            store.send(.loadAccounts)
        }
        
    }
    
    struct StatusImage: View {
        var account: AccountData?
        
        init(_ account: AccountData?) {
            self.account = account
        }
        
        var body: some View {
            VStack {
                if account != nil {
                    Image(systemName: "checkmark.circle")
                }else {
                    Image(systemName: "xmark.circle")
                }
            }
            .padding()
            .font(.system(size: 20))
            
        }
    }
    
    
}

import SwiftUI

import LoginCore

public struct AccountsView: View {
    
    let accounts: [Account]
    
    let createAccountTapped: () -> ()
    let assistantTapped: () -> ()
    let loginTapped: (Account) -> ()
    let deleteTapped: (Account) -> ()
    let editTapped: (Account) -> ()
    let resetTapped: () -> ()
    
    public init(accounts: [Account], createAccountTapped: @escaping () -> Void, assistantTapped: @escaping () -> Void, loginTapped: @escaping (Account) -> Void, deleteTapped: @escaping (Account) -> Void, editTapped: @escaping (Account) -> Void, resetTapped: @escaping () -> Void) {
        self.accounts = accounts
        self.createAccountTapped = createAccountTapped
        self.assistantTapped = assistantTapped
        self.loginTapped = loginTapped
        self.deleteTapped = deleteTapped
        self.editTapped = editTapped
        self.resetTapped = resetTapped
    }
    
    public var body: some View {
        VStack {
            HStack {
                Button(action: createAccountTapped){
                    Image(systemName: "plus")
                        .padding()
                        .font(.system(size: 20))
                }
                Spacer()
            }
            if(accounts.count == 0) {
                AccountsAssistantView(
                    assistantTapped: assistantTapped
                )
            } else {
                List {
                
                    ForEach(accounts, id: \.identifier){ account in
                        Button(action: {
                            loginTapped(account)
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(account.name)
                                        .bold()
                                    // .foregroundStyle(Color.theme)
                                    
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
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .padding()
                            }
                        }
                        .foregroundStyle(Color.contrast)
                        .buttonStyle(BorderlessButtonStyle())
                        .swipeActions(edge: .trailing) {
                            Button(role: .cancel) {
                                deleteTapped(account)
                            } label: {
                                Text("Delete")
                                    .foregroundColor(.white)
                            }
                            .tint(.red)
                            
                            Button(role: .cancel) {
                                editTapped(account)
                            } label: {
                                Text("Edit")
                                    .foregroundColor(.white)
                            }
                            .tint(.gray)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: resetTapped){
                Text("Reset")
                    .foregroundStyle(Color.red)
            }
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

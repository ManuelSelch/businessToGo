import SwiftUI

import LoginCore

public struct AccountView: View {
    let account: Account
    
    let backTapped: () -> ()
    let kimaiAccountTapped: (Account) -> ()
    let taigaAccountTapped: (Account) -> ()
    let nameChanged: (String) -> ()
 
    @State var name = ""
    
    public init(account: Account, backTapped: @escaping () -> Void, kimaiAccountTapped: @escaping (Account) -> Void, taigaAccountTapped: @escaping (Account) -> Void, nameChanged: @escaping (String) -> Void) {
        self.account = account
        self.backTapped = backTapped
        self.kimaiAccountTapped = kimaiAccountTapped
        self.taigaAccountTapped = taigaAccountTapped
        self.nameChanged = nameChanged
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Text("Account")
                    .bold()
                
                HStack {
                    Button(action : {
                        backTapped()
                    }){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                    }
                    Spacer()
                }
                
            }
            
            TextField("Workspace", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        kimaiAccountTapped(account)
                    }) {
                        HStack {
                            StatusImage(account.kimai)
                            Text("Kimai")
                        }
                    }
                    
                    Button(action: {
                        taigaAccountTapped(account)
                    }) {
                        HStack {
                            StatusImage(account.taiga)
                            Text("Taiga")
                        }
                    }
                    
                    Spacer()
                    
                    
                }
                Spacer()
            }
        }
        .padding()
        .onAppear {
            self.name = account.name
        }
        .onChange(of: name){  
            nameChanged(name)
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

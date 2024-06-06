import SwiftUI

import LoginCore

struct AccountView: View {
    let account: Account
    
    let backTapped: () -> ()
    let kimaiAccountTapped: (Account) -> ()
    let taigaAccountTapped: (Account) -> ()
    let nameChanged: (String) -> ()
 
    @State var name = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action : {
                    backTapped()
                }){
                    Image(systemName: "arrow.left")
                        .padding()
                        .font(.system(size: 20))

                }
                Spacer()
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
        .background(Color.background)
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

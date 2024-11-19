import SwiftUI

import LoginCore

public struct AccountView: View {
    let account: Account

    let kimaiAccountTapped: () -> ()
    let taigaAccountTapped: () -> ()
    let nameSaveTapped: (String) -> ()
 
    @State var name = ""
    
    public init(account: Account, kimaiAccountTapped: @escaping () -> Void, taigaAccountTapped: @escaping () -> Void, nameSaveTapped: @escaping (String) -> Void) {
        self.account = account
        self.kimaiAccountTapped = kimaiAccountTapped
        self.taigaAccountTapped = taigaAccountTapped
        self.nameSaveTapped = nameSaveTapped
    }
    
    public var body: some View {
        VStack {
            Text("Account")
                .bold()
            
            TextField("Workspace", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    if(name != account.name) {
                        nameSaveTapped(name)
                    }
                }
                
            
            HStack {
                Spacer()
                VStack {
                    Button(action: kimaiAccountTapped) {
                        HStack {
                            StatusImage(account.kimai)
                            Text("Kimai")
                        }
                    }
                    
                    Button(action: taigaAccountTapped) {
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

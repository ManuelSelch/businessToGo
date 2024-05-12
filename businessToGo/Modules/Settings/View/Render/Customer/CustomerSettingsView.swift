import SwiftUI

struct CustomerSettingsView: View {
    var customer: [KimaiCustomer]
    
    var body: some View {
        VStack {
            List {
                ForEach(customer) { customer in
                    Text(customer.name)
                }
            }
        }
        .tint(Color.theme)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }){
                    Image(systemName: "plus")
                        .padding()
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme)
                }
            }
        }
    }
}



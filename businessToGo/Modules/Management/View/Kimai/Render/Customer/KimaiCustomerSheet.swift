import SwiftUI

struct KimaiCustomerSheet: View {
    var customer: KimaiCustomer
    var onSave: (KimaiCustomer) -> ()
    
    @State var name = ""
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var customer = customer
                        customer.name = name
                        onSave(customer)
                    }){
                        let isCreate = (customer.id == KimaiCustomer.new.id)
                        let label = isCreate ? "Create" : "Save"
                        Text(label)
                            .foregroundStyle(Color.theme)
                    }
                }
            }
        }
        .onAppear {
            name = customer.name
        }
        
    }
}

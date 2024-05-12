import SwiftUI

struct KimaiCustomersView: View {
    let customers: [KimaiCustomer]
    let onCustomerSelected: (Int) -> Void
    
    
    var customersFiltered: [KimaiCustomer] {
        var c = customers
        c.sort { $0.name < $1.name }
        return c
    }
    
    var body: some View {
        VStack {
            if(customersFiltered.count == 0){
                Text("no customers loaded yet ...")
            }
            
            List(customersFiltered, id: \.id) { customer in
                Button(action: {
                    onCustomerSelected(customer.id)
                }){
                    Text(customer.name)
                        .foregroundColor(Color.theme)
                }
            }
            
        }
        .background(Color.background)
    }
}

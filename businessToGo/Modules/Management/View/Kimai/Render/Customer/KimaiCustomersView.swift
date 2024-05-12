import SwiftUI

struct KimaiCustomersView: View {
    let customers: [KimaiCustomer]
    let onCustomerSelected: (Int) -> Void
    
    
    var customersFiltered: [KimaiCustomer] {
        var c = customers
        c.sort { $0.name < $1.name }
        return c
    }
    
    var onEdit: (KimaiCustomer) -> ()
    
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
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                    }
                    .tint(.red)
                    
                    Button(role: .cancel) {
                        onEdit(customer)
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .tint(.gray)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        onEdit(KimaiCustomer.new)
                    }){
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.theme)
                    }
                }
            }
            
        }
        .background(Color.background)
    }
}

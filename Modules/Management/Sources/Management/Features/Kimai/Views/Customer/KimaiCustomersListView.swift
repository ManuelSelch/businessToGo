import SwiftUI
import OfflineSync
import ManagementDependencies

struct KimaiCustomersListView: View {
    let customers: [KimaiCustomer]
    let customerChanges: [DatabaseChange]
    
    let customerTapped: (Int) -> ()
    let customerEditTapped: (KimaiCustomer) -> ()
    
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
                KimaiCustomerCard(
                    customer: customer, 
                    change: customerChanges.first(where: { $0.recordID == customer.id }),
                    customerTapped: {customerTapped(customer.id) }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        customerEditTapped(customer)
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
                        customerEditTapped(KimaiCustomer.new)
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

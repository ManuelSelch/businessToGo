import SwiftUI
import OfflineSync

struct KimaiCustomersView: View {
    let customers: [KimaiCustomer]
    let changes: [DatabaseChange]
    let router: (RouteAction<ManagementRoute>) -> ()
    
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
                    change: changes.first(where: { $0.recordID == customer.id }),
                    onCustomerSelected: { router(.push(.kimai(.projects(for: $0)))) }
                )
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            router(.presentSheet(.kimai(.customer(customer))))
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
                        router(.presentSheet(.kimai(.customer(KimaiCustomer.new))))
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


#Preview {
    let customers = [
        KimaiCustomer(id: 0, name: "Customer 1", color: "ffa500", teams: []),
        KimaiCustomer(id: 1, name: "Customer 2", color: "008080", teams: [])
    ]
    return KimaiCustomersView(
        customers: customers,
        changes: [],
        router: { _ in}
    )
}

import SwiftUI
import OfflineSync
import ComposableArchitecture

struct KimaiCustomersListView: View {
    let store: StoreOf<KimaiCustomersListFeature>
    
    var customersFiltered: [KimaiCustomer] {
        var c = store.customers.records
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
                    change: store.customers.changes.first(where: { $0.recordID == customer.id }),
                    customerTapped: { store.send(.customerTapped(customer.id)) } 
                )
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            store.send(.customerEditTapped(customer))
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
                        store.send(.customerEditTapped(KimaiCustomer.new))
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

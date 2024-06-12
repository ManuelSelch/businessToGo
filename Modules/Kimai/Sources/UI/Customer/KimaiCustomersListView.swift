import SwiftUI

import KimaiCore

public struct KimaiCustomersListView: View {
    let customers: [KimaiCustomer]
    
    let customerTapped: (Int) -> ()
    let customerEditTapped: (KimaiCustomer) -> ()
    
    var customersFiltered: [KimaiCustomer] {
        var c = customers
        c.sort { $0.name < $1.name }
        return c
    }
    
    public init(customers: [KimaiCustomer], customerTapped: @escaping (Int) -> Void, customerEditTapped: @escaping (KimaiCustomer) -> Void) {
        self.customers = customers
        self.customerTapped = customerTapped
        self.customerEditTapped = customerEditTapped
    }
    
    public var body: some View {
        VStack {
            if(customersFiltered.count == 0){
                Text("no customers loaded yet ...")
            }
            
            List(customersFiltered, id: \.id) { customer in
                KimaiCustomerCard(
                    customer: customer, 
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
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        customerEditTapped(KimaiCustomer.new)
                    }){
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.theme)
                    }
                }
                #endif
            }
        }
        .background(Color.background)
    }
}

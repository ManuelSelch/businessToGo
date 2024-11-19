import SwiftUI

import CommonUI
import KimaiCore
import OfflineSyncCore

public struct KimaiCustomersListView: View {
    let customers: [KimaiCustomer]
    
    let customerTapped: (Int) -> ()
    let customerEditTapped: (KimaiCustomer) -> ()
    let customerDeleteTapped: (KimaiCustomer) -> ()
    let customerCreated: (KimaiCustomer) -> ()
    
    var customersFiltered: [KimaiCustomer] {
        var c = customers
        c.sort { $0.name < $1.name }
        return c
    }
    
    public init(
        customers: [KimaiCustomer], changes: [DatabaseChange],
        customerTapped: @escaping (Int) -> Void,
        customerEditTapped: @escaping (KimaiCustomer) -> Void,
        customerDeleteTapped: @escaping (KimaiCustomer) -> Void,
        customerCreated: @escaping (KimaiCustomer) -> Void
    ) {
        self.customers = customers
        self.customerTapped = customerTapped
        self.customerEditTapped = customerEditTapped
        self.customerDeleteTapped = customerDeleteTapped
        self.customerCreated = customerCreated
    }
    
    public var body: some View {
        List {
            CustomTextField("New Customer") { name in
                var customer = KimaiCustomer.new
                customer.name = name
                customerCreated(customer)
            }
            
            
            
            ForEach(customersFiltered) { customer in
                KimaiCustomerCard(
                    customer: customer, 
                    customerTapped: {customerTapped(customer.id) }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        customerDeleteTapped(customer)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                    }
                    .tint(.red)
                    .padding()
                    
                    Button(role: .cancel) {
                        customerEditTapped(customer)
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .tint(.gray)
                }
            }
        }
        .listStyle(.plain)
    
    }
}

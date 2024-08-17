import SwiftUI

import KimaiCore

struct KimaiCustomerCard: View {
    var customer: KimaiCustomer
    var customerTapped: () -> ()
    
    var body: some View {
        HStack {
            if let color = customer.color, color != "" {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: color))
            }
            
            Button(action: customerTapped){
                Text(customer.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}

#Preview {
    let customer = KimaiCustomer.sample
    return KimaiCustomerCard(
        customer: customer,
        customerTapped: { }
    )
}

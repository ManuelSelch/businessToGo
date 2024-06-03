import SwiftUI
import OfflineSync
import ManagementDependencies

struct KimaiCustomerCard: View {
    var customer: KimaiCustomer
    var change: DatabaseChange?
    var customerTapped: () -> ()
    
    var body: some View {
        HStack {
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }
            
            if let color = customer.color {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: color))
            }
            
            Button(action: {
                customerTapped()
            }){
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

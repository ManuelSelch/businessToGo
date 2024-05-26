import SwiftUI
import OfflineSync

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
    let customer = KimaiCustomer(id: 0, name: "Customer 1", color: "ffa500", teams: [])
    return KimaiCustomerCard(
        customer: customer,
        customerTapped: { }
    )
}

import SwiftUI
import OfflineSync

struct KimaiCustomerCard: View {
    var customer: KimaiCustomer
    var change: DatabaseChange?
    var onCustomerSelected: (Int) -> ()
    
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
                onCustomerSelected(customer.id)
            }){
                Text(customer.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}

#Preview {
    let customer = KimaiCustomer(id: 0, name: "Customer 1", color: "ffa500")
    return KimaiCustomerCard(
        customer: customer,
        onCustomerSelected: { _ in}
    )
}

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
            
            Button(action: {
                onCustomerSelected(customer.id)
            }){
                Text(customer.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}

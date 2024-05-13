import SwiftUI

struct KimaiCustomerSheet: View {
    var customer: KimaiCustomer
    var onSave: (KimaiCustomer) -> ()
    
    @State var name = ""
    @State var color: String?
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Name: ")
                    Spacer()
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                HStack {
                    Text("Farbe: ")
                    Spacer()
                    CustomColorPicker(selectedColor: $color)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var customer = customer
                        customer.name = name
                        customer.color = color
                        onSave(customer)
                    }){
                        let isCreate = (customer.id == KimaiCustomer.new.id)
                        let label = isCreate ? "Create" : "Save"
                        Text(label)
                            .foregroundStyle(Color.theme)
                    }
                }
            }
        }
        .onAppear {
            name = customer.name
            color = customer.color
        }
        
    }
}


#Preview {
    let customer = KimaiCustomer.new
    return KimaiCustomerSheet(
        customer: customer,
        onSave: {_ in return}
    )
}

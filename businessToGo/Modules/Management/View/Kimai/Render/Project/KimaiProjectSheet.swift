import SwiftUI

struct KimaiProjectSheet: View {
    var project: KimaiProject
    var customers: [KimaiCustomer]
    
    @State var name = ""
    @State var selectedCustomer: Int = 0
    
    var onSave: (KimaiProject) -> ()
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Kunde", selection: $selectedCustomer) {
                    ForEach(customers, id: \.id) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var project = project
                        project.name = name
                        project.customer = selectedCustomer
                        onSave(project)
                    }){
                        let isCreate = project.id == KimaiProject.new.id
                        let label = isCreate ? "Create": "Save"
                        Text(label)
                    }
                }
            }
        }
        .onAppear {
            name = project.name
            selectedCustomer = customers.first { $0.id == project.customer }?.id ?? 0
        }
    }
}

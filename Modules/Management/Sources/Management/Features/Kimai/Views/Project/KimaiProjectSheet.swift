import SwiftUI

import KimaiCore

struct KimaiProjectSheet: View {
    
    let project: KimaiProject
    let customers: [KimaiCustomer]
    
    let saveTapped: (KimaiProject) -> ()
    
    @State var name = ""
    @State var selectedCustomer: Int = 0
    @State var color: String?
    
    
    
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
                
                HStack {
                    Text("Farbe: ")
                    Spacer()
                    CustomColorPicker(selectedColor: $color)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var project = project
                        project.name = name
                        project.customer = selectedCustomer
                        project.color = color
                        saveTapped(project)
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
            selectedCustomer = customers.first { $0.id == project.customer }?.id ?? customers.first?.id ?? 0
            color = project.color
        }
    }
}

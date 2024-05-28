import SwiftUI
import ComposableArchitecture

struct KimaiProjectSheet: View {
    let store: StoreOf<KimaiProjectSheetFeature>
    
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
                    ForEach(store.customers, id: \.id) {
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
                        var project = store.project
                        project.name = name
                        project.customer = selectedCustomer
                        project.color = color
                        store.send(.saveTapped(project))
                    }){
                        let isCreate = store.project.id == KimaiProject.new.id
                        let label = isCreate ? "Create": "Save"
                        Text(label)
                    }
                }
            }
        }
        .onAppear {
            name = store.project.name
            selectedCustomer = store.customers.first { $0.id == store.project.customer }?.id ?? store.customers.first?.id ?? 0
            color = store.project.color
        }
    }
}

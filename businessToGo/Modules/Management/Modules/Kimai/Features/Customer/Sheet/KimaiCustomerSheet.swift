import SwiftUI
import ComposableArchitecture

struct KimaiCustomerSheet: View {
    let store: StoreOf<KimaiCustomerSheetFeature>
    
    var selectedTeams: [KimaiTeam] {
        return store.teams.filter { store.customer.teams.contains($0.id) }
    }
    
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
                
                
                HStack {
                    Text("Teams: ")
                    Spacer()
                    
                    ForEach(selectedTeams, id: \.id) { team in
                        Button(action: {}) {
                            Text(team.name)
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.bordered)
                        .disabled(true)
                    }
                }
                .padding(.horizontal)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var customer = store.customer
                        customer.name = name
                        customer.color = color
                        store.send(.saveTapped(customer))
                    }){
                        let isCreate = (store.customer.id == KimaiCustomer.new.id)
                        let label = isCreate ? "Create" : "Save"
                        Text(label)
                            .foregroundStyle(Color.theme)
                    }
                }
            }
            
            .onAppear {
                name = store.customer.name
                color = store.customer.color
            }
        }
    }
}

import SwiftUI

import KimaiCore

struct KimaiCustomerSheet: View {
    let customer: KimaiCustomer
    let teams: [KimaiTeam]
    
    let saveTapped: (KimaiCustomer) -> ()
    
    var selectedTeams: [KimaiTeam] {
        return teams.filter { customer.teams.contains($0.id) }
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
                        var customer = customer
                        customer.name = name
                        customer.color = color
                        saveTapped(customer)
                    }){
                        let isCreate = (customer.id == KimaiCustomer.new.id)
                        let label = isCreate ? "Create" : "Save"
                        Text(label)
                            .foregroundStyle(Color.theme)
                    }
                }
            }
            
            .onAppear {
                name = customer.name
                color = customer.color
            }
        }
    }
}

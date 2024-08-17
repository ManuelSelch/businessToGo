import SwiftUI

import KimaiCore
import CommonUI

public struct KimaiActivitySheet: View {
    
    let activity: KimaiActivity
    let projects: [KimaiProject]
    
    let saveTapped: (KimaiActivity) -> ()
    
    @State var name = ""
    @State var selectedProject: Int = 0
    @State var color: String?
    
    public init(activity: KimaiActivity, projects: [KimaiProject], saveTapped: @escaping (KimaiActivity) -> Void) {
        self.activity = activity
        
        self.projects = projects
        self.saveTapped = saveTapped
    }
    
    public var body: some View {
        VStack {
            List {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Project", selection: $selectedProject) {
                    ForEach(projects, id: \.id) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                HStack {
                    Text("Color: ")
                    Spacer()
                    CustomColorPicker(selectedColor: $color)
                }
                
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        var activity = activity
                        activity.name = name
                        activity.project = selectedProject
                        activity.color = color ?? ""
                        saveTapped(activity)
                    }){
                        let isCreate = activity.id == KimaiActivity.new.id
                        let label = isCreate ? "Create": "Save"
                        Text(label)
                    }
                }
                #endif
            }
        }
        .onAppear {
            name = activity.name
            selectedProject = projects.first { $0.id == activity.project }?.id ?? projects.first?.id ?? 0
            color = activity.color
        }
    }
}

import SwiftUI

import KimaiCore
import CommonUI

public struct KimaiActivitySheet: View {
    
    let activity: KimaiActivity
    let projects: [KimaiProject]
    
    let saveTapped: (KimaiActivity) -> ()
    
    @State var name = ""
    @State var selectedProject: Int?
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
                    Text("----").tag(nil as Int?)
                    ForEach(projects, id: \.id) { project in
                        Text(project.name).tag(project.id as Int?)
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
            if(activity.project == nil) {
                selectedProject = nil
            } else {
                selectedProject = projects.first { $0.id == activity.project }?.id ?? projects.first?.id
            }
            
            color = activity.color
        }
    }
}

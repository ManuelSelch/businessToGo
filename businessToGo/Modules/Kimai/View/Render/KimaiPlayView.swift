//
//  KimaiPlayView.swift
//  businessToGo
//
//  Created by Admin  on 14.04.24.
//

import SwiftUI

struct KimaiPlayView: View {
    @Binding var isPresentingPlayView: Bool
    
    let timesheet: KimaiTimesheet
    
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    let activities: [KimaiActivity]
    
    let onSave: (_ project: Int, _ activity: Int, _ begin: String, _ description: String) -> Void
    
    @State var selectedCustomer: Int = 0
    @State var selectedProject: Int = 0
    @State var selectedActivity: Int = 0
    @State var description: String = ""
    @State var startTime: Date = Date.now
    
    init(
        timesheet: KimaiTimesheet,
        isPresentingPlayView: Binding<Bool>,
        customers: [KimaiCustomer],
        projects: [KimaiProject],
        activities: [KimaiActivity],
        onSave: @escaping (_ project: Int, _ activity: Int, _ begin: String, _ description: String) -> Void
    )
    {
        self._isPresentingPlayView = isPresentingPlayView
        self.timesheet = timesheet
        self.customers = customers
        self.projects = projects
        self.activities = activities
        self.onSave = onSave
        
        let project = projects.first { $0.id == timesheet.project }
        selectedCustomer = customers.first { $0.id ==  project?.id }?.id ?? 0
        
        selectedProject = timesheet.project
        selectedActivity = timesheet.activity
        description = timesheet.description ?? ""
        startTime = Date.now
    }
    
    
    
    
    var projectsFiltered: [KimaiProject] {
        return projects.filter {
            $0.customer == selectedCustomer
        }
    }
    
    var activitiesFiltered: [KimaiActivity] {
        var t = activities.filter {
            $0.project == selectedProject || $0.project == nil
        }
        t.sort { $0.name < $1.name }
        return t
    }
    
    var body: some View {
        NavigationStack() {
            Form {
                Section(header: Text("Branch Info")) {
                    
                    Picker("customer", selection: $selectedCustomer) {
                        ForEach(customers, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("project", selection: $selectedProject) {
                        ForEach(projectsFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("activity", selection: $selectedActivity) {
                        ForEach(activitiesFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    HStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "clock.fill")
                            VStack {
                                Text("Start time")
                                    .font(.system(size: 8))
                                
                                DatePicker("start time", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                        
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "pause.circle.fill")
                                .foregroundStyle(Color.red)
                            VStack {
                                Text("End time")
                                    .font(.system(size: 8))
                                
                                Text("Stop")
                                    .foregroundStyle(Color.red)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        isPresentingPlayView = false
                        onSave(selectedProject, selectedActivity, "\(startTime)", description)
                    }
                }
            }
        }
        .onDisappear {
            
        }
    }
}


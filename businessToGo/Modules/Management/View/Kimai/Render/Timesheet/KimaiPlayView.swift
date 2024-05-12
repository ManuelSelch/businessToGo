//
//  KimaiPlayView.swift
//  businessToGo
//
//  Created by Admin  on 14.04.24.
//

import SwiftUI

struct KimaiPlayView: View {
    var timesheet: KimaiTimesheet
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    var activities: [KimaiActivity]
    
    let onSave: (_ timesheet: KimaiTimesheet) -> Void
    
    @State var selectedCustomer: Int = 0
    @State var selectedProject: Int = 0
    @State var selectedActivity: Int = 0
    @State var description: String = ""
    @State var startTime: Date = Date.now
    @State var endTime: Date = Date.now
    @State var isEndTime: Bool = false
    
    @Binding var timesheetView: KimaiTimesheet?
    
    
    
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
        Form {
            Section(header: Text("Branch Info")) {
                
                Picker("Kunde", selection: $selectedCustomer) {
                    ForEach(customers, id: \.id) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Projekt", selection: $selectedProject) {
                    ForEach(projectsFiltered, id: \.id) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Tätigkeit", selection: $selectedActivity) {
                    ForEach(activitiesFiltered, id: \.id) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                TextField("Beschreibung", text: $description)
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
                        if(isEndTime){
                            Image(systemName: "clock.fill")
                        }else {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.red)
                        }
                        VStack {
                            Text("End time")
                                .font(.system(size: 8))
                            
                            if(isEndTime) {
                                DatePicker("end time", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }else {
                                Text("Stop")
                                    .foregroundStyle(Color.red)
                            }
                                
                        }
                    }
                    
                    Spacer()
                }
                
            }
        }
        
        
        .onAppear {
            let isCreate = (timesheet.id == KimaiTimesheet.new.id)
            
            if(isCreate){
                selectedCustomer = customers.first?.id ?? 0
                selectedProject = projectsFiltered.first?.id ?? 0
                selectedActivity = activitiesFiltered.first?.id ?? 0
            }else {
                let project = projects.first { $0.id == timesheet.project }
                selectedCustomer = customers.first { $0.id ==  project?.customer }?.id ?? 0
                
                selectedProject = timesheet.project
                selectedActivity = timesheet.activity
                description = timesheet.description ?? ""
                startTime = getDate(timesheet.begin) ?? Date.now
                endTime = getDate(timesheet.end ?? "") ?? Date.now
                isEndTime = (timesheet.end != nil)

            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let isCreate = timesheet.id == KimaiTimesheet.new.id
                let label = isCreate ? "Create" : "Save"
                Button(label) {
                    var timesheet = timesheet
                    timesheet.project = selectedProject
                    timesheet.activity = selectedActivity
                    timesheet.begin = "\(startTime)"
                    timesheet.end = isEndTime ? "\(endTime)" : nil
                    timesheet.description = description
                    
                    onSave(timesheet)
                    
                    timesheetView = nil
                }
            }
        }
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
}


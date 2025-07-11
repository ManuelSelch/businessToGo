import SwiftUI

import KimaiCore

public struct KimaiTimesheetSheet: View {
    let timesheet: KimaiTimesheet
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    let activities: [KimaiActivity]
    
    let saveTapped: (KimaiTimesheet) -> ()
    
    @State private var selectedCustomer: Int = 0
    @State private var selectedProject: Int = 0
    @State private var selectedActivity: Int = 0
    @State private var description: String = ""
    @State private var startTime: Date = Date().roundTo15Minutes()
    @State private var endTime: Date = Date().roundTo15Minutes()
    @State private var isEndTime: Bool = false
    
    var projectsFiltered: [KimaiProject] {
        projects.filter { $0.customer == selectedCustomer }
    }
    
    var activitiesFiltered: [KimaiActivity] {
        var filteredActivities = activities
        if let project = projects.first(where: { $0.id == selectedProject }), !project.globalActivities {
            filteredActivities = filteredActivities.filter { $0.project == project.id }
        }
        return filteredActivities.sorted { $0.name < $1.name }
    }
    
    public init(timesheet: KimaiTimesheet, customers: [KimaiCustomer], projects: [KimaiProject], activities: [KimaiActivity], saveTapped: @escaping (KimaiTimesheet) -> Void) {
        self.timesheet = timesheet
        self.customers = customers
        self.projects = projects
        self.activities = activities
        self.saveTapped = saveTapped
    }
    
    public var body: some View {
        VStack {
           
            
            Form {
                Section(header: Text("Debug")) {
                    Text("customer: \(selectedCustomer)")
                    Text("project: \(selectedProject)")
                    Text("activity: \(selectedActivity)")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Branch Info")) {
                    Picker("Kunde", selection: $selectedCustomer) {
                        ForEach(customers, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedCustomer) { old in
                        selectedProject = projectsFiltered.first(where: { $0.id == selectedProject })?.id ?? projectsFiltered.first?.id ?? 0
                    }
                    
                    Picker("Projekt", selection: $selectedProject) {
                        ForEach(projectsFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedProject) { old in
                        selectedActivity = activitiesFiltered.first(
                            where: { $0.id == selectedActivity }
                        )?.id ?? activitiesFiltered.first?.id ?? 0
                    }
                    
                    Picker("Tätigkeit", selection: $selectedActivity) {
                        ForEach(activitiesFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    
                    TextField("Beschreibung", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    VStack {
                        VStack {
                            Text("Start time")
                                .font(.system(size: 8))
                            DatePicker("start time", selection: $startTime)
                                .labelsHidden()
                        }
                        if isEndTime {
                            VStack {
                                Text("End time")
                                    .font(.system(size: 8))
                                DatePicker("end time", selection: $endTime)
                                    .labelsHidden()
                            }
                        } else {
                            VStack {
                                Text("End time")
                                    .font(.system(size: 8))
                                Text("Stop")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        isEndTime = true
                                    }
                            }
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
             
            .onAppear {
                initializeState()
            }
   
            .navigationBarItems(trailing: Button(timesheet.id == KimaiTimesheet.new.id ? "Create" : "Save") {
                var updatedTimesheet = timesheet
                updatedTimesheet.project = selectedProject
                updatedTimesheet.activity = selectedActivity
                updatedTimesheet.begin = "\(startTime)"
                updatedTimesheet.end = isEndTime ? "\(endTime)" : nil
                updatedTimesheet.description = description
                
                saveTapped(updatedTimesheet)
            })
        }
    }
    
    private func initializeState() {
        if let project = projects.first(where: { $0.id == timesheet.project }),
           let customer = customers.first(where: { $0.id == project.customer }) {
            selectedCustomer = customer.id
            selectedProject = project.id
        } else {
            selectedCustomer = customers.first?.id ?? 0
            selectedProject = projectsFiltered.first?.id ?? 0
        }
        
        if let activity = activitiesFiltered.first(where: { $0.id == timesheet.activity }) {
            selectedActivity = activity.id
        } else {
            selectedActivity = activitiesFiltered.first?.id ?? 0
        }
        
        description = timesheet.description ?? ""
        startTime = getDate(from: timesheet.begin) ?? Date()
        endTime = getDate(from: timesheet.end) ?? Date()
        isEndTime = timesheet.end != nil
    }
    
    private func getDate(from dateStr: String?) -> Date? {
        guard let dateStr = dateStr else { return nil }
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        return try? Date(dateStr, strategy: strategy)
    }
}

#Preview {
    KimaiTimesheetSheet(
        timesheet: KimaiTimesheet.sample,
        customers: [],
        projects: [],
        activities: [],
        saveTapped: { _ in }
    )
}

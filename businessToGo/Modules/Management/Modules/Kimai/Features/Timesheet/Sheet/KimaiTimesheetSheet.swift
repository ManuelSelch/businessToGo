import SwiftUI
import ComposableArchitecture

struct KimaiTimesheetSheet: View {
    let store: StoreOf<KimaiTimesheetSheetFeature>
    
    @State private var selectedCustomer: Int = 0
    @State private var selectedProject: Int = 0
    @State private var selectedActivity: Int = 0
    @State private var description: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var isEndTime: Bool = false
    
    var projectsFiltered: [KimaiProject] {
        store.projects.filter { $0.customer == selectedCustomer }
    }
    
    var activitiesFiltered: [KimaiActivity] {
        var filteredActivities = store.activities
        if let project = store.projects.first(where: { $0.id == selectedProject }), !project.globalActivities {
            filteredActivities = filteredActivities.filter { $0.project == project.id }
        }
        return filteredActivities.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Branch Info")) {
                    Picker("Kunde", selection: $selectedCustomer) {
                        ForEach(store.customers, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedCustomer) { old, new in
                        if(old != 0){
                            selectedProject = projectsFiltered.first?.id ?? 0
                        }
                    }
                    
                    Picker("Projekt", selection: $selectedProject) {
                        ForEach(projectsFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedProject) { old, new in
                        if(old != 0){
                            selectedActivity = activitiesFiltered.first?.id ?? 0
                        }
                    }
                    
                    Picker("Tätigkeit", selection: $selectedActivity) {
                        ForEach(activitiesFiltered, id: \.id) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    
                    TextField("Beschreibung", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Start time")
                                .font(.system(size: 8))
                            DatePicker("start time", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        Spacer()
                        if isEndTime {
                            VStack {
                                Text("End time")
                                    .font(.system(size: 8))
                                DatePicker("end time", selection: $endTime, displayedComponents: .hourAndMinute)
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
                        Spacer()
                    }
                }
            }
            .onAppear {
                initializeState()
            }
            .navigationBarItems(trailing: Button(store.timesheet.id == KimaiTimesheet.new.id ? "Create" : "Save") {
                var updatedTimesheet = store.timesheet
                updatedTimesheet.project = selectedProject
                updatedTimesheet.activity = selectedActivity
                updatedTimesheet.begin = "\(startTime)"
                updatedTimesheet.end = isEndTime ? "\(endTime)" : nil
                updatedTimesheet.description = description
                
                store.send(.saveTapped(updatedTimesheet))
            })
        }
    }
    
    private func initializeState() {
        if let project = store.projects.first(where: { $0.id == store.timesheet.project }),
           let customer = store.customers.first(where: { $0.id == project.customer }) {
            selectedCustomer = customer.id
            selectedProject = project.id
        } else {
            selectedCustomer = store.customers.first?.id ?? 0
            selectedProject = projectsFiltered.first?.id ?? 0
        }
        
        if let activity = activitiesFiltered.first(where: { $0.id == store.timesheet.activity }) {
            selectedActivity = activity.id
        } else {
            selectedActivity = activitiesFiltered.first?.id ?? 0
        }
        
        description = store.timesheet.description ?? ""
        startTime = getDate(from: store.timesheet.begin) ?? Date()
        endTime = getDate(from: store.timesheet.end) ?? Date()
        isEndTime = store.timesheet.end != nil
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

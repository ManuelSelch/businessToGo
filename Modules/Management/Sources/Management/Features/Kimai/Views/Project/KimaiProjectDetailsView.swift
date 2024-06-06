import SwiftUI
import MyChart
import OfflineSync

import KimaiCore
import AppCore

struct KimaiProjectDetailsView: View {
    let project: KimaiProject
    let customer: KimaiCustomer?
    let timesheets: [KimaiTimesheet]
    let timesheetChanges: [DatabaseChange]
    let activities: [KimaiActivity]
    let activityChanges: [DatabaseChange]
    let users: [KimaiUser]
    
    let deleteTapped: (KimaiTimesheet) -> ()
    let editTapped: (KimaiTimesheet) -> ()
    let activityTapped: (KimaiActivity) -> ()
    
    enum ChartSelection: String, CaseIterable {
        case time = "Arbeitszeit"
        case user = "Benutzer"
        case activity = "Tätigkeit"
    }

    var timesheetsFiltered: [KimaiTimesheet] {
        return timesheets.filter { $0.project == project.id }
    }
    
    
    var totalHours: TimeInterval {
        KimaiTimesheet.totalHours(of: timesheetsFiltered)
    }
    var totalRate: Double {
        KimaiTimesheet.totalRate(of: timesheetsFiltered)
    }
    
    var lastEntry: Date? {
        KimaiTimesheet.lastEntryDate(of: timesheetsFiltered)
    }
    
    enum Menu {
        case summary
        case sessions
        case activities
    }
    
    @State var selectedMenu: Menu = .summary
    
    @State var selectedChart: ChartSelection = .time
    
    var body: some View {
        VStack {
            Picker("Menu", selection: $selectedMenu){
                Text("Übersicht")
                    .tag(Menu.summary)
                Text("Sessions")
                    .tag(Menu.sessions)
                Text("Tätigkeiten")
                    .tag(Menu.activities)
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch(selectedMenu){
            case .summary:
                List {
                    Section("General") {
                        ListItem(customer?.name ?? "--", label: "Kunde")
                        ListItem(project.name, label: "Projekt")
                        ListItem(MyFormatter.duration(totalHours), label: "Arbeitszeit Gesamt")
                        ListItem(MyFormatter.rate(totalRate), label: "Umsatz Gesamt")
                        if let date = lastEntry {
                            ListItem(MyFormatter.date(date), label: "Letzer Eintrag")
                        }
                    }
                    
                    Picker("Charts", selection: $selectedChart){
                        ForEach(ChartSelection.allCases, id: \.self){ chart in
                            Text(chart.rawValue)
                                .tag(chart)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    
                    VStack {
                        switch(selectedChart){
                        case .time:
                            ChartBarView(hoursByMonth(), Color.theme)
                        case .user:
                            ChartPieView(hoursByUser())
                        case .activity:
                            ChartPieView(hoursByActivity())
                        }
                    }
                    .id(selectedChart)
                    
                    
                }
            case .sessions:
                KimaiTimesheetsListView(
                    projects: [project],
                    timesheets: timesheets.filter { $0.project == project.id },
                    timesheetChanges: timesheetChanges,
                    activities: activities,
                    deleteTapped: deleteTapped,
                    editTapped: editTapped
                )
            case .activities:
                KimaiActivityListView(
                    activities: activities.filter { $0.project == project.id || $0.project == nil },
                    activityChanges: activityChanges,
                    activityTapped: activityTapped
                )
            }
            
            
        }
    }
    
    @ViewBuilder func ListItem(_ value: String, label: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
        }
    }
}

extension KimaiProjectDetailsView {
    func hoursByMonth() -> [ChartItem] {
        var items: [ChartItem] = []
        
        for i in 1...12 {
            items.append(
                .init(
                    id: i,
                    name: Date.monthName(of: i),
                    value: KimaiTimesheet.totalHours(of: timesheetsFiltered.filter { $0.getBeginDate()?.month() == i } ) / 3600
                )
            )
        }
                  
        return items
    }
    
    func hoursByUser() -> [ChartItem] {
        var items: [ChartItem] = []
        
        var users: [Int] = []
        
        for timesheet in self.timesheetsFiltered {
            if(!users.contains(timesheet.user)) {
                users.append(timesheet.user)
            }
        }
        
        for user in users {
            items.append(
                .init(
                    id: user,
                    name: self.users.first{ $0.id == user }?.username ?? "--",
                    value: KimaiTimesheet.totalHours(of: timesheetsFiltered.filter { $0.user == user }) / 3600
                )
            )
        }
        
        return items
    }
    
    func hoursByActivity() -> [ChartItem] {
        var items: [ChartItem] = []
        
        var activities: [Int] = []
        
        for timesheet in self.timesheetsFiltered {
            if(!activities.contains(timesheet.activity)) {
                activities.append(timesheet.activity)
            }
        }
        
        for activity in activities {
            items.append(
                .init(
                    id: activity,
                    name: self.activities.first { $0.id == activity }?.name ?? "--",
                    value: KimaiTimesheet.totalHours(of: self.timesheetsFiltered.filter { $0.activity == activity }) / 3600
                )
            )
        }
        
        return items
    }
    
}


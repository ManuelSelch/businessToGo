import SwiftUI

import KimaiCore
import CommonUI
import CommonCore

public struct KimaiTimesheetsListView: View {
    let projects: [KimaiProject]
    
    let timesheets: [KimaiTimesheet]
    let activities: [KimaiActivity]
    
    let deleteTapped: (KimaiTimesheet) -> ()
    let editTapped: (KimaiTimesheet) -> ()
    
    
    // computed properties
    let timesheetsByDate: Dictionary<Date, [KimaiTimesheet]>
    let dateKeys: [Dictionary<Date, [KimaiTimesheet]>.Keys.Element]
    
    @State private var isExpanded: Date?
    
    public init(projects: [KimaiProject], timesheets: [KimaiTimesheet], activities: [KimaiActivity], deleteTapped: @escaping (KimaiTimesheet) -> Void, editTapped: @escaping (KimaiTimesheet) -> Void) {
        self.projects = projects
        self.timesheets = timesheets
        self.activities = activities
        self.deleteTapped = deleteTapped
        self.editTapped = editTapped
        
        var timesheets = timesheets
        timesheets.sort(by: { $0.begin > $1.begin })
        timesheetsByDate = Dictionary(grouping: timesheets, by: {
            Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: $0.getBeginDate() ?? Date.now
                )
            ) ?? Date.now
            
        })
    
        dateKeys = timesheetsByDate.keys.sorted(by: >)
        
    }
     
    
    public var body: some View {
        List {
            ForEach(dateKeys, id: \.self){ date in
                
                if #available(iOS 17.0, *) {
                    Section(
                        isExpanded: Binding<Bool> (
                            get: {
                                return isExpanded == date
                            },
                            set: { isExpanding in
                                if isExpanding {
                                    isExpanded = date
                                } else {
                                    isExpanded = nil
                                }
                            }
                        ),
                        content: {
                            let timesheetEntries = timesheetsByDate[date] ?? []
                            ForEach(timesheetEntries){ timesheet in
                                KimaiTimesheetCard(
                                    timesheet: timesheet,
                                    project: projects.first { $0.id == timesheet.project },
                                    activity: activities.first{ $0.id == timesheet.activity }
                                )
                                .swipeActions(edge: .trailing) {
                                    Button(role: .cancel) {
                                        deleteTapped(timesheet)
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                    }
                                    .tint(.red)
                                    .padding()
                                    
                                    Button(role: .cancel) {
                                        editTapped(timesheet)
                                    } label: {
                                        Text("Edit")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(maxHeight: .infinity)
                                    .background(.gray)
                                }
                                
                                
                                
                            }
                        },
                        header: {
                            HStack {
                                Text(MyFormatter.date(date))
                                Spacer()
                                Text(
                                    MyFormatter.duration(
                                        KimaiTimesheet.totalHours(of: timesheetsByDate[date] ?? [])
                                    )
                                )
                            }
                            .font(.system(size: 15))
                            .textCase(.uppercase)
                            .foregroundStyle(Color.textHeaderSecondary)
                        }
                    )
                } else {
                    Section(
                        content: {
                            let timesheetEntries = timesheetsByDate[date] ?? []
                            ForEach(timesheetEntries){ timesheet in
                                KimaiTimesheetCard(
                                    timesheet: timesheet,
                                    project: projects.first { $0.id == timesheet.project },
                                    activity: activities.first{ $0.id == timesheet.activity }
                                )
                                .swipeActions(edge: .trailing) {
                                    Button(role: .cancel) {
                                        deleteTapped(timesheet)
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                    }
                                    .tint(.red)
                                    .padding()
                                    
                                    Button(role: .cancel) {
                                        editTapped(timesheet)
                                    } label: {
                                        Text("Edit")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(maxHeight: .infinity)
                                    .background(.gray)
                                }
                                
                                
                                
                            }
                        },
                        header: {
                            HStack {
                                Text(MyFormatter.date(date))
                                Spacer()
                                Text(
                                    MyFormatter.duration(
                                        KimaiTimesheet.totalHours(of: timesheetsByDate[date] ?? [])
                                    )
                                )
                            }
                            .font(.system(size: 15))
                            .textCase(.uppercase)
                            .foregroundStyle(Color.textHeaderSecondary)
                        }
                    )
                }
                
            
                
            }
        }
        .listStyle(.sidebar)
    }
  
    
}

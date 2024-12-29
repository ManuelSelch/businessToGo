import SwiftUI
import OfflineSyncCore
import MyChart

import CommonCore
import KimaiCore
import KimaiUI

class ReportViewModel: ObservableObject {
    @Published var groupedData: [KimaiCustomer: [KimaiProject: Double]] = [:] // Customer -> Project -> Total Hours

    func processRecords(records: [KimaiTimesheet], projects: [KimaiProject], customers: [KimaiCustomer]) {
        var result: [KimaiCustomer: [KimaiProject: Double]] = [:]

        for record in records {
            guard let project = projects.first(where: {$0.id == record.project}) else { continue }
            guard let customer = customers.first(where: {$0.id == project.customer}) else { continue }

            result[customer, default: [:]][project,default: 0]  += record.calculateDuration() ?? 0
        }

        DispatchQueue.main.async {
            self.groupedData = result
        }
    }
}

struct ReportsView: View {
    // MARK: - State
    let timesheets: [KimaiTimesheet]
    let timesheetChanges: [DatabaseChange]
    let projects: [KimaiProject]
    let activities: [KimaiActivity]
    let customers: [KimaiCustomer]
    @Binding var selectedProject: Int?
    @Binding var selectedDate: Date
    @Binding var selectedReportType: ReportType
    
    // MARK: - Action
    let calendarTapped: () -> ()
    let filterTapped: () -> ()
    let playTapped: () -> ()
    let editTapped: (KimaiTimesheet) -> ()
    let deleteTapped: (KimaiTimesheet) -> ()
    
    @StateObject var viewModel = ReportViewModel()
    
    
    // MARK: - View
    var timesheetsFiltered: [KimaiTimesheet] {
        var timesheets = timesheets
        
        if let project = selectedProject {
            timesheets = timesheets.filter { $0.project == project }
        }
        
        switch(selectedReportType){
        case .day:
            return timesheets.filter{ $0.getBeginDate()?.isDay(of: selectedDate) ?? false }
        case .week:
            return timesheets.filter { $0.getBeginDate()?.isWeekOfYear(of: selectedDate) ?? false }
        case .month:
            return timesheets.filter { $0.getBeginDate()?.isMonth(of: selectedDate) ?? false }
        case .year:
            return timesheets.filter { $0.getBeginDate()?.isYear(of: selectedDate) ?? false }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0){
            getHeader()
            getReportChart()
                .frame(maxHeight: 100)
            getBody()
        }
        .onAppear {
            viewModel.processRecords(records: timesheets, projects: projects, customers: customers)
        }
    }
}

extension ReportsView {
    
    @ViewBuilder
    func getHeader() -> some View {
        ReportHeaderView(
            selectedReportType: $selectedReportType,
            selectedDate: $selectedDate ,
            selectedProject: $selectedProject,
            projects: projects,
            
            calendarTapped: calendarTapped,
            filterTapped: filterTapped,
            playTapped: playTapped
            
        )
    }
    
    @ViewBuilder
    func getBody() -> some View {
        switch(selectedReportType) {
        case .day:
            getTimesheets()
        case .week:
            getTimesheets()
        case .month:
            getSummary()
        case .year:
            getSummary()
        }
    }
    
    @ViewBuilder
    func getSummary() -> some View {
        List {
            ForEach(Array(viewModel.groupedData.keys), id: \.id) { customer in
                Section(
                    content: {
                        if let projects = viewModel.groupedData[customer] {
                            ForEach(Array(projects.keys), id: \.id) { project in
                                HStack {
                                    Text(project.name)
                                    Spacer()
                                    
                                    Text(
                                        MyFormatter.duration(projects[project] ?? 0.0)
                                    )
                                      
                                }
                            }
                        } else {
                            Text("No projects available.")
                        }
                    },
                    header: {
                        HStack {
                            Text(customer.name)
                            Spacer()
                            Text("00:00")
                        }
                        .font(.system(size: 15))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.textHeaderSecondary)
                    }
                )
                .listRowBackground(Color.clear)
            }
        }


    }
    
    
    @ViewBuilder
    func getTimesheets() -> some View {
       
        KimaiTimesheetsListView(
            projects: projects,
            timesheets: timesheetsFiltered,
            activities: activities,
            timesheetChanges: timesheetChanges,
            deleteTapped: deleteTapped,
            editTapped: editTapped
        )
         
    }
    
    @ViewBuilder
    func getReportChart() -> some View {
        ReportSummaryView(timesheets: timesheetsFiltered)
        
        switch(selectedReportType){
        case .week:
            ChartBarView([
                .init(id: 0, name: "Mo", value: getTotalTime(for: timesheetsFiltered, weekday: 2)),
                .init(id: 1, name: "Di", value: getTotalTime(for: timesheetsFiltered, weekday: 3)),
                .init(id: 2, name: "Mi", value: getTotalTime(for: timesheetsFiltered, weekday: 4)),
                .init(id: 3, name: "Do", value: getTotalTime(for: timesheetsFiltered, weekday: 5)),
                .init(id: 4, name: "Fr", value: getTotalTime(for: timesheetsFiltered, weekday: 6)),
                .init(id: 5, name: "Sa", value: getTotalTime(for: timesheetsFiltered, weekday: 7)),
                .init(id: 6, name: "So", value: getTotalTime(for: timesheetsFiltered, weekday: 1))
            ], Color.theme)
        default:
            ChartPieView(customers.map { .init(id: $0.id, name: $0.name, value: 10) })
                .chartLegend(.hidden)
        }
    }
}

extension ReportsView {
    func getTotalTime(for timesheets: [KimaiTimesheet], weekday: Int) -> TimeInterval {
        let timesheets = timesheets.filter { $0.getBeginDate()?.getWeekday() == weekday }
        
        return KimaiTimesheet.totalHours(of: timesheets) / 3600
    }
}

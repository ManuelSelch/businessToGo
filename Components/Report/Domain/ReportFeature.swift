import Foundation
import Redux

struct ReportFeature: Reducer {
    struct State: Equatable, Codable {
        var months: [String] = Calendar.current.shortMonthSymbols
        var selectedDate: Date = Date.today
        var selectedProject: Int?
        var selectedReportType: ReportType = .week
    }
    
    enum Action: Equatable, Codable {
        case dateSelected(Date)
        case projectSelected(Int?)
        case reportTypeSelected(ReportType)
        
        case previousYearTapped
        case nextYearTapped
        case monthTapped(String)
    }
    
    func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action) {
        case let .dateSelected(date):
            state.selectedDate = date
        case let .projectSelected(project):
            state.selectedProject = project
        case let .reportTypeSelected(reportType):
            state.selectedReportType = reportType
        
        case .previousYearTapped:
            var dateComponent = DateComponents()
            dateComponent.year = -1
            state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
        case .nextYearTapped:
            var dateComponent = DateComponents()
            dateComponent.year = +1
            state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
        case let .monthTapped(month):
            var dateComponent = DateComponents()
            dateComponent.day = 1
            dateComponent.month =  state.months.firstIndex(of: month)! + 1
            dateComponent.year = Int(state.selectedDate.year())
            state.selectedDate = Calendar.current.date(from: dateComponent)!
        }
        
        return .none
    }
    
}

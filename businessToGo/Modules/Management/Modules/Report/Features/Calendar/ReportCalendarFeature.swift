import Foundation
import ComposableArchitecture

@Reducer
struct ReportCalendarFeature {
    @ObservableState
    struct State: Equatable {
        @Shared var selectedDate: Date
        var months: [String] = Calendar.current.shortMonthSymbols
    }
    
    enum Action {
        case lastYearTapped
        case nextYearTapped
        case monthTapped(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .lastYearTapped:
            var dateComponent = DateComponents()
            dateComponent.year = -1
            state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
            return .none
        case .nextYearTapped:
            var dateComponent = DateComponents()
            dateComponent.year = +1
            state.selectedDate = Calendar.current.date(byAdding: dateComponent, to: state.selectedDate)!
            return .none
        case let .monthTapped(month):
            var dateComponent = DateComponents()
            dateComponent.day = 1
            dateComponent.month =  state.months.firstIndex(of: month)! + 1
            dateComponent.year = Int(state.selectedDate.year())
            state.selectedDate = Calendar.current.date(from: dateComponent)!
            return .none
        }
    }
}

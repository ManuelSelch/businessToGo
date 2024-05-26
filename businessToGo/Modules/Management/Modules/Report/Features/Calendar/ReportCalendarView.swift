import SwiftUI
import ComposableArchitecture

struct ReportCalendarView: View {
    let store: StoreOf<ReportCalendarFeature>
    
    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    var body: some View {
        VStack {
            //year picker
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 24.0)
                    .onTapGesture {
                        store.send(.lastYearTapped)
                    }
                
                Text(String(store.selectedDate.year()))
                         .fontWeight(.bold)
                         .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        store.send(.nextYearTapped)
                    }
            }.padding(15)
            
            //month picker
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.months, id: \.self) { item in
                    Text(item)
                    .font(.headline)
                    .frame(width: 60, height: 33)
                    .bold()
                    .foregroundStyle(
                        store.months.firstIndex(of: item)! + 1 == store.selectedDate.month() ?
                        Color.background : Color.contrast
                    )
                    .background(
                        store.months.firstIndex(of: item)! + 1 == store.selectedDate.month() ?
                        Color.theme : Color.clear
                    )
                    .cornerRadius(8)
                    .onTapGesture {
                        store.send(.monthTapped(item))
                    }
               }
            }
            .padding(.horizontal)
        }
    }
}

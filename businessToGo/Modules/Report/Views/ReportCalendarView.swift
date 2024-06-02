import SwiftUI

struct ReportCalendarView: View {
    
    let months: [String]
    let selectedDate: Date
    
    let lastYearTapped: () -> ()
    let nextYearTapped: () -> ()
    let monthTapped: (String) -> ()
    
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
                        lastYearTapped()
                    }
                
                Text(String(selectedDate.year()))
                         .fontWeight(.bold)
                         .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        nextYearTapped()
                    }
            }.padding(15)
            
            //month picker
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(months, id: \.self) { item in
                    Text(item)
                    .font(.headline)
                    .frame(width: 60, height: 33)
                    .bold()
                    .foregroundStyle(
                        months.firstIndex(of: item)! + 1 == selectedDate.month() ?
                        Color.background : Color.contrast
                    )
                    .background(
                        months.firstIndex(of: item)! + 1 == selectedDate.month() ?
                        Color.theme : Color.clear
                    )
                    .cornerRadius(8)
                    .onTapGesture {
                        monthTapped(item)
                    }
               }
            }
            .padding(.horizontal)
        }
    }
}

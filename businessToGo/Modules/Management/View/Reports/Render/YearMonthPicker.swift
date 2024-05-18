import SwiftUI

struct YearMonthPickerView: View {
    @Binding var selectedDate: Date
    
    let months: [String] = Calendar.current.shortMonthSymbols
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
                        var dateComponent = DateComponents()
                        dateComponent.year = -1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                    }
                
                Text(String(selectedDate.year()))
                         .fontWeight(.bold)
                         .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = 1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
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
                        var dateComponent = DateComponents()
                        dateComponent.day = 1
                        dateComponent.month =  months.firstIndex(of: item)! + 1
                        dateComponent.year = Int(selectedDate.year())
                        print(item)
                        selectedDate = Calendar.current.date(from: dateComponent)!
                        print(selectedDate)
                    }
               }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    YearMonthPickerView(selectedDate: .constant(Date.now))
}

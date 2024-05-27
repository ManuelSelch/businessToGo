import SwiftUI
import ComposableArchitecture

struct KimaiTimesheetPopup: View {
    @Bindable var store: StoreOf<KimaiTimesheetPopupFeature>
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var durationStr = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                store.send(.timesheetTapped)
            }){
                VStack(alignment: .leading) {
                    Text(durationStr)
                        .bold()
                    
                    Text(store.customer.name)
                }
                
                VStack(alignment: .leading) {
                    
                    Text(store.project.name)
                        .bold()
                    Text(store.activity.name)
                    
                }
            }
            .foregroundStyle(Color.contrast)
            
            Spacer()
            
            Button(action: {
                store.send(.stopTapped)
            }){
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.red)
            }
            
            Spacer()
            
           
        }
        .padding()
        .onReceive(timer, perform: { _ in
            durationStr = store.timesheet.getDuration()
        })
        
    }
}

#Preview {
    KimaiTimesheetPopup(
        store: .init(initialState: .init(
            timesheet: .sample,
            customer: .sample,
            project: .sample,
            activity: .sample
        )) {
            KimaiTimesheetPopupFeature()
        }
    )
}


import SwiftUI

struct KimaiTimesheetPopup: View {
    var timesheet: KimaiTimesheet
    var customer: KimaiCustomer
    var project: KimaiProject
    var activity: KimaiActivity
    
    var onShow: () -> ()
    var onStop: () -> ()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var durationStr = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                onShow()
            }){
                VStack(alignment: .leading) {
                    Text(durationStr)
                        .bold()
                    
                    Text(customer.name)
                }
                
                VStack(alignment: .leading) {
                    
                    Text(project.name)
                        .bold()
                    Text(activity.name)
                    
                }
            }
            .foregroundStyle(Color.black)
            
            Spacer()
            
            Button(action: {
                onStop()
            }){
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.red)
            }
            
           
        }
        .padding()
        .onReceive(timer, perform: { _ in
            durationStr = timesheet.getDuration()
        })
        
    }
}


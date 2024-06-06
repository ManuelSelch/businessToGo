import SwiftUI

import KimaiCore

struct KimaiTimesheetPopup: View {
    let customer: KimaiCustomer
    let project: KimaiProject
    let activity: KimaiActivity
    let timesheet: KimaiTimesheet
    
    let timesheetTapped: () -> ()
    let stopTapped: () -> ()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var durationStr = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                timesheetTapped()
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
            .foregroundStyle(Color.contrast)
            
            Spacer()
            
            Button(action: {
              stopTapped()
            }){
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.red)
            }
            
            Spacer()
            
           
        }
        .padding()
        .onReceive(timer, perform: { _ in
            durationStr = timesheet.getDuration()
        })
        
    }
}

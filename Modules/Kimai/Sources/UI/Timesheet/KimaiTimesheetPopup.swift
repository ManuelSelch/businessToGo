import SwiftUI

import KimaiCore

public struct KimaiTimesheetPopup: View {
    let customer: KimaiCustomer
    let project: KimaiProject
    let activity: KimaiActivity
    let timesheet: KimaiTimesheet
    
    let timesheetTapped: () -> ()
    let stopTapped: () -> ()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State var durationStr = ""
    
    public init(customer: KimaiCustomer, project: KimaiProject, activity: KimaiActivity, timesheet: KimaiTimesheet, timesheetTapped: @escaping () -> Void, stopTapped: @escaping () -> Void) {
        self.customer = customer
        self.project = project
        self.activity = activity
        self.timesheet = timesheet
        self.timesheetTapped = timesheetTapped
        self.stopTapped = stopTapped
    }
    
    public var body: some View {
        HStack {
            Spacer()
            
            Button(action: timesheetTapped){
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
            
            Button(action: stopTapped){
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.red)
            }
            
            Spacer()
            
           
        }
        .padding()
        .background(Color.themeGray)
        .clipShape(.rect(cornerRadius: 10))
        .padding()
        
        .onAppear {
            durationStr = timesheet.getDuration()
        }
        
        .onReceive(timer, perform: { _ in
            durationStr = timesheet.getDuration()
        })
        
    }
}

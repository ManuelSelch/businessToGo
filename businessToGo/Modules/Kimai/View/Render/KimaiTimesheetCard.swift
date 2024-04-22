//
//  KimaiTimesheetCard.swift
//  businessToGo
//
//  Created by Admin  on 22.04.24.
//

import SwiftUI

struct KimaiTimesheetCard: View {
    let timesheet: KimaiTimesheet
    let change: DatabaseChange?
    let activity: KimaiActivity?
    
    let onTimesheetClicked: (Int) -> Void
    
    var body: some View {
        Button(action: {
            onTimesheetClicked(timesheet.id)
        }){
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }else {
                Text("")
            }
            
            if let date = getDate(timesheet.begin){
                Text(date.formatted())
            }else{
                Text(timesheet.begin)
            }
            
            if let activity = activity {
                Text(activity.name)
            }else {
                Text("\(timesheet.activity)")
            }
            
            if(timesheet.end == nil){
                Image(systemName: "pause.circle.fill")
                    .foregroundStyle(Color.red)
            }else {
                Text("")
            }
        }
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
}

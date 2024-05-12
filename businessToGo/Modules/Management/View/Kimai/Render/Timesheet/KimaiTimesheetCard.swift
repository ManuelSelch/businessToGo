//
//  KimaiTimesheetCard.swift
//  businessToGo
//
//  Created by Admin  on 22.04.24.
//

import SwiftUI
import OfflineSync

struct KimaiTimesheetCard: View {
    let timesheet: KimaiTimesheet
    let change: DatabaseChange? 
    let activity: KimaiActivity?
    
    let onTimesheetClicked: (Int) -> Void
    let onStopClicked: (Int) -> Void
    
    var body: some View {
        GridRow {
            
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }else {
                Text("")
            }
            
            Button(action: {
                onTimesheetClicked(timesheet.id)
            }){
                if let date = getDate(timesheet.begin){
                    Text(date.formatted(date: .omitted, time: .shortened))
                        .foregroundColor(Color.theme)
                }else{
                    Text(timesheet.begin)
                        .foregroundColor(Color.theme)
                }
            }
            
            if let activity = activity {
                Text(activity.name)
            }else {
                Text("\(timesheet.activity)")
            }
            
            if(timesheet.end == nil){
                Button(action: {
                    onStopClicked(timesheet.id)
                }){
                    Image(systemName: "pause.circle.fill")
                        .foregroundStyle(Color.red)
                }
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

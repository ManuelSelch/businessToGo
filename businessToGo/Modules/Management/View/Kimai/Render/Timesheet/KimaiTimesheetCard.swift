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
    
    let onStopClicked: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 0){
            
            
            
            if let begin = getDate(timesheet.begin) {
                Text(begin.formatted(date: .omitted, time: .shortened))
                
                if let end = getDate(timesheet.end ?? "") {
                    Text(" - ")
                    
                    Text(end.formatted(date: .omitted, time: .shortened))
                }else{
                    Text("")
                }
            } else {
                Text("")
            }
            
            Spacer()
            
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }
            
            Spacer()
            
            Text(activity?.name ?? "\(timesheet.activity)")
            
            
            /*
            if(timesheet.end == nil){
                Button(action: {
                    onStopClicked(timesheet.id)
                }){
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.red)
                }
            }else {
                Text("")
            }
             */
            
            
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

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
    let project: KimaiProject?
    let change: DatabaseChange?
    let activity: KimaiActivity?
    
    var body: some View {
        HStack {
            VStack {
                let end = getDate(timesheet.end ?? "")?.formatted(date: .omitted, time: .shortened) ?? "--:--"
                Text(end)
                    .font(.system(size: 12))
                
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.contrast)
                    .font(.system(size: 12))
                    .frame(width: 30, height: 10)
                    .rotationEffect(.degrees(90))
                
                let begin = getDate(timesheet.begin)?.formatted(date: .omitted, time: .shortened) ?? "--:--"
                Text(begin)
                    .font(.system(size: 12))
                
                
            }
            
            Rectangle()
               .frame(width: 2, height: 50)
               .foregroundColor(Color(hex: project?.color ?? "#000000"))
            
            if(change != nil) {
                Image(systemName: "icloud.and.arrow.up")
            }
            
            VStack(alignment: .leading) {
                Text(activity?.name ?? "\(timesheet.activity)")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(Color.theme)
                
                Spacer()
                
                Text(timesheet.description ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textHeaderSecondary)
                    .italic()
            }
            
           
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(timesheet.getDuration())
                    .font(.system(size: 12, weight: .heavy))
                
                Spacer()
                
                Text(project?.name ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textHeaderSecondary)
                    .italic()
            }
        }
        .foregroundStyle(Color.contrast)
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
}

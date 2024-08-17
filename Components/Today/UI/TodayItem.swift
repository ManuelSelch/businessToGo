import SwiftUI

import KimaiCore

struct TodayItem: View {
    var timesheet: KimaiTimesheet
    var customer: KimaiCustomer?
    var project: KimaiProject?
    var isLastItem: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 0) {
                Image(systemName: "circle.fill")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(.secondary)
                
                if(!isLastItem) {
                    Rectangle()
                        .fill(.secondary)
                        .frame(maxWidth: 2, maxHeight: 105, alignment: .center)
                }
            }
            VStack(alignment: .leading) {
                Text(customer?.name ?? "--")
                    .font(.system(.body, weight: .semibold))
                Text(project?.name ?? "--")
                    .font(.system(.body, weight: .semibold))
                Text(
                    (timesheet.getBeginDate()?.formatted(date: .omitted, time: .shortened) ?? "00:00") +
                    " -- " +
                    (timesheet.getEndDate()?.formatted(date: .omitted, time: .shortened) ?? "IN PROGRESS")
                )
                    .foregroundStyle(.secondary)
                    .padding(.top)
                Text(timesheet.getDuration())
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
            }

            Spacer()
            VStack(spacing: 10) {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                Image(systemName: "pencil.circle")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
            }
            .frame(alignment: .center)
        }
    }
}

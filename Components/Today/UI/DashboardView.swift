import SwiftUI
import MyChart

import CommonUI
import KimaiCore

struct DashboardView: View {
    let timesheets: [KimaiTimesheet]
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    
    let customerTapped: (KimaiCustomer) -> ()
    
    var body: some View {
        ZStack(alignment: .top) {
            Image.background
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .edgesIgnoringSafeArea(.all)
   
            
            VStack {
                Text("Hi Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.title2, weight: .bold))
                Text("Guten Morgen")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                ZStack {
                    Rectangle()
                        .fill(Color.themeGray.opacity(0.9))
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.5), radius: 5)
                        
                    
                    VStack {
                        ReportSummaryView(timesheets: timesheets)
                        
                        ChartBarView([
                            .init(id: 0, name: "Mo", value: getTotalTime(for: timesheets, weekday: 2)),
                            .init(id: 1, name: "Di", value: getTotalTime(for: timesheets, weekday: 3)),
                            .init(id: 2, name: "Mi", value: getTotalTime(for: timesheets, weekday: 4)),
                            .init(id: 3, name: "Do", value: getTotalTime(for: timesheets, weekday: 5)),
                            .init(id: 4, name: "Fr", value: getTotalTime(for: timesheets, weekday: 6)),
                            .init(id: 5, name: "Sa", value: getTotalTime(for: timesheets, weekday: 7)),
                            .init(id: 6, name: "So", value: getTotalTime(for: timesheets, weekday: 1))
                        ], Color.theme)
                    }
                }
                .frame(height: 190)
                
               
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 0) {
                        ForEach(customers) { customer in
                            Button(action: { customerTapped(customer) }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.themeGray)
                                        .clipShape(.rect(cornerRadius: 10))
                                        .aspectRatio(1/1, contentMode: .fit)
                                        // .frame(maxWidth: 100)
                                        .shadow(color: Color.black.opacity(0.5), radius: 2)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if let color = customer.color, color != "" {
                                                Circle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 20)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color(hex: color), lineWidth: 2)
                                                    )
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                        
                                        Text(customer.name)
                                            .font(.system(.footnote))
                                            .foregroundStyle(Color.theme)
                                            .bold()
                                        
                                        let projectCount = projects.filter({$0.customer == customer.id}).count
                                        let label = projectCount == 1 ? "Projekt" : "Projekte"
                                        
                                        
                                        Text("\(projectCount) \(label)")
                                            .font(.system(.caption))
                                            .foregroundStyle(Color.textHeaderSecondary)
                                        
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.top, 30)
                }
            }
            .padding([.top, .horizontal], 30)
        }
    }
}

extension DashboardView {
    func getTotalTime(for timesheets: [KimaiTimesheet], weekday: Int) -> TimeInterval {
        let timesheets = timesheets.filter { $0.getBeginDate()?.getWeekday() == weekday }
        
        return KimaiTimesheet.totalHours(of: timesheets) / 3600
    }
}

import SwiftUI

import KimaiCore

struct ChangeView: View {
    
    let currentCustomer: KimaiCustomer
    let currentProject: KimaiProject
    let currentActivity: KimaiActivity
    
    let projectChangeTapped: () -> ()
    let activityChangeTapped: (_ for: Int) -> ()
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 3, height: 100)
                .clipped()
            VStack {
                Button(action: projectChangeTapped) {
                    Text(currentCustomer.name + " / " + currentProject.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                }
                Spacer()
                
                Button(action: {
                    activityChangeTapped(currentProject.id)
                }) {
                    Text(currentActivity.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .foregroundStyle(.blue)
                }
            }
            .frame(height: 70)
            .clipped()
            .padding(15)
            
            Image(systemName: "chevron.right")
                .symbolRenderingMode(.monochrome)
                .padding()
        }
        .background(Color(.systemGray6))
    }
}

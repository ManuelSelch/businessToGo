//
//  KimaiHeaderView.swift
//  businessToGo
//
//  Created by Admin  on 16.04.24.
//

import SwiftUI

struct KimaiHeaderView: View {
    @Binding var timesheetView: KimaiTimesheet?
    let route: KimaiRoute
    
    var projectId: Int? {
        switch(route){
            case .project(let id): return id
            default: return nil
        }
    }
    
    let onChart: () -> Void
    let onProjectClicked: (Int) -> Void
    
    var body: some View {
        HStack {
            if(route == .customers){
                Button(action: {
                    onChart()
                }){
                    Image(systemName: "chart.bar.xaxis.ascending")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            }
            
            if let id = projectId {
                Button(action: {
                    onProjectClicked(id)
                }){
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            }
            
            
            Button(action: {
                timesheetView = KimaiTimesheet.new
            }){
                Image(systemName: "play.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme)
            }
            
        }
    }
}

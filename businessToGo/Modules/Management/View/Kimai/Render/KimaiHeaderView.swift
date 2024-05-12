//
//  KimaiHeaderView.swift
//  businessToGo
//
//  Created by Admin  on 16.04.24.
//

import SwiftUI

struct KimaiHeaderView: View {
    @Binding var isPresentingPlayView: Bool
    let route: KimaiRoute
    
    var projectId: Int? {
        switch(route){
            case .project(let id): return id
            default: return nil
        }
    }
    
    var isTimesheet: Bool {
        switch(route){
            case .timesheet(_): return true
            default: return false
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
            
            if(!isTimesheet){
                Button(action: {
                    isPresentingPlayView = true
                }){
                    Image(systemName: "play.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color.theme)
                }
            }
        }
    }
}

//
//  KimaiHeaderView.swift
//  businessToGo
//
//  Created by Admin  on 16.04.24.
//

import SwiftUI

struct KimaiHeaderView: View {
    @Binding var isPresentingPlayView: Bool
    let isBack: Bool
    let onSync: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            if(isBack){
                Button(action: {
                    onBack()
                }){
                    Image(systemName: "arrow.left")
                }
            }
            
            Spacer()
            
            Button(action: {
                onSync()
            }){
                Image(systemName: "arrow.triangle.2.circlepath")
            }
            
            Button(action: {
                isPresentingPlayView = true
                // selectedCustomer = project.customer
                // selectedProject = project.id
            }){
                Image(systemName: "play.fill")
            }
        }
        .padding()
    }
}

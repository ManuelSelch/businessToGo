//
//  TaigaHeaderView.swift
//  businessToGo
//
//  Created by Admin  on 16.04.24.
//

import SwiftUI

struct TaigaHeaderView: View {
    let isBack: Bool
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
        }
        .padding()
    }
}

//
//  Header.swift
//  businessToGo
//
//  Created by Admin  on 12.04.24.
//

import SwiftUI

struct Header: View {
    @Binding var showSidebar: Bool
    var title: String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(title)
                    .foregroundColor(Color.white)
                Spacer()
            }
                
            HStack {
                Spacer()
                
                Button(action: {
                    self.showSidebar.toggle()
                }){
                    if(showSidebar){
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                    } else{
                        Image(systemName: "text.justify")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                    }
                    
                }
            }
                
        }
        .padding()
        .background(Color.theme)
    }
}

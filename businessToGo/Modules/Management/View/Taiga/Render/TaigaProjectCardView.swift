//
//  ProjectCardView.swift
//  businessToGo
//
//  Created by Admin  on 16.04.24.
//

import SwiftUI

struct TaigaProjectCardView: View {
    private var width: CGFloat = 400
    private var height: CGFloat = 50
    
    @State var project: TaigaProject
    let image: CustomImage?
    
    init(_ project: TaigaProject, _ image: CustomImage?){
        self.project = project
        self.image = image
    }
    
    
    
    var body: some View {
        HStack {
            // store.state.projectImages[project.id]
            if let image = image {
                CustomImageHelper.create(from: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                    .scaledToFit()
                    .frame(width: width/3)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                
                    .scaledToFit()
                    .frame(width: width/3)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            
            
            VStack(alignment: .leading) {
                
                Text(project.name).font(.title3).fontWeight(.bold)
                    .foregroundColor(Color.theme)
                
                Spacer()
                
                Text(project.name)
                    .font(.footnote)
                    .foregroundColor(Color.textHeaderSecondary)
            }
            
            Spacer()
        }
        .frame(width: width, height: height)
        .padding()
        .background(Color.background)
        .cornerRadius(10)
        
    }
    
    
}

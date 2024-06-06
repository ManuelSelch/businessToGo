import SwiftUI

import TaigaCore

struct TaigaProjectCardView: View {
    private var width: CGFloat = 400
    private var height: CGFloat = 50
    
    @State var project: TaigaProject
    let image: UIImage?
    
    init(_ project: TaigaProject, _ image: UIImage?){
        self.project = project
        self.image = image
    }
    
    
    
    var body: some View {
        HStack {
            // store.state.projectImages[project.id]
            if let image = image {
                Image(uiImage: image)
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
                    .foregroundColor(Color.contrast)
            }
            
            Spacer()
        }
        .frame(width: width, height: height)
        .padding()
        .background(Color.background)
        .cornerRadius(5)
        
    }
    
    
}

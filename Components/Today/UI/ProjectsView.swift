import SwiftUI

import KimaiCore

struct ProjectsView: View {
    let projects: [KimaiProject]
    
    let projectTapped: (KimaiProject) -> ()
    
    var body: some View {
        ScrollView(showsIndicators: false)  {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(projects) { project in
                    Button(action: {
                        projectTapped(project)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(Color.themeGray)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 6)
                                )
                                .aspectRatio(1/1, contentMode: .fit)
                                .shadow(radius: 2)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    if let color = project.color, color != "" {
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
                                
                                HStack {
                                    Spacer()
                                    Text(project.name)
                                        .font(.system(.footnote))
                                        .bold()
                                        .foregroundStyle(Color.theme)
                                    Spacer()
                                }
                                
                            }
                            .padding()
                        }
                        .frame(maxWidth: 150)
                    }
                }
            }
            .padding(.vertical)
        }
        .padding(.top, 40)
    }
}

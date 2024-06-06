import SwiftUI

import TaigaCore

struct TaigaProjectsView: View {
    let projects: [TaigaProject]
    let images: [Int: UIImage]
    
    let onProjectClicked: (TaigaProject) -> Void
    let onLoadImage: (TaigaProject) -> Void
    
    var projectsFiltered: [TaigaProject] {
        var p = projects
        p.sort { $0.name < $1.name }
        return p
    }
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 450))]
            )
            {
                ForEach(projectsFiltered) { project in
                    Button(action: {
                        onProjectClicked(project)
                    }) {
                        TaigaProjectCardView(project, images[project.id])
                            .onAppear {
                                onLoadImage(project)
                            }
                    }
                }
                .padding()
            }
            .background(Color.background)
            .padding()
            
        }
    }
}

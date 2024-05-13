import SwiftUI

struct Header: View {
    @EnvironmentObject var router: AppRouter
    @Binding var showSidebar: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(router.tab.title)
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

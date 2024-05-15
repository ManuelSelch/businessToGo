import SwiftUI

struct Header: View {
    @EnvironmentObject var router: AppRouter
    @Binding var showSidebar: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                switch(router.tab){
                case .login:
                    Text(router.tab.title)
                case .management:
                    Text(router.management.title)
                case .kimaiSettings:
                    Text(router.settings.title)
                }
               
                Spacer()
            }
            .foregroundStyle(Color.white)
                
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

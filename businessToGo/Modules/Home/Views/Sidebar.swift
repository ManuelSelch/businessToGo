import SwiftUI
import Redux

struct Sidebar: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: Store<AppScreen, MenuAction>
    
    @Binding var showSidebar: Bool
    
    var body: some View {
        List {
            
            
            Section(header: Text("Dashboard")) {
                Button(action: {
                    router.tab = .management
                    showSidebar = false
                }){
                    Text("Time")
                }
                
                Button(action: {
                    router.tab = .management
                    showSidebar = false
                }){
                    Text("Project")
                }
            }
            
            Section(header: Text("Settings")) {
                Button(action: {
                    store.send(.resetDatabase)
                    showSidebar = false
                }){
                    Text("Reset Database")
                }
                
                Button(action: {
                    router.tab = .kimaiSettings
                    showSidebar = false
                }){
                    Text("Einstellungen")
                }
                
                Button(action: {
                    store.send(.logout)
                    showSidebar = false
                }){
                    Text("Logout")
                }
                
            }
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
        .frame(maxWidth: .infinity)
        .offset(x: showSidebar ? 0 : max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
        .animation(.easeInOut(duration: 0.3), value: showSidebar)
        .background(Color.black.opacity(showSidebar ? 0.5 : 0))
    }
    
}
    



import SwiftUI
import Redux

struct Sidebar: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject var store: Store<AppState, AppAction, Environment>
    
    @Binding var showSidebar: Bool
    
    var body: some View {
        List {
            Text("hello world")
        }
        .edgesIgnoringSafeArea(.bottom)
        
        .frame(maxWidth: .infinity)
        #if os(iOS)
        .offset(x: showSidebar ? 0 : max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
        #elseif os(macOS)
        .offset(x: showSidebar ? 0 : max(NSScreen.main?.frame.width ?? 0, NSScreen.main?.frame.height ?? 0))
        #endif
        .animation(.easeInOut(duration: 0.3), value: showSidebar)
        .background(Color.background.opacity(showSidebar ? 1 : 0))
    }
    
}
    



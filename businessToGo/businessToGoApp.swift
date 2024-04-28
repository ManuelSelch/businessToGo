import SwiftUI
import Combine
import Redux

var Env = Environment()

@main
struct businessToGoApp: App {
    let store = Store(
        initialState: AppState(),
        reducer: AppState.reduce,
        middlewares: [LogMiddleware().handle]
    )
    
    @State var showSidebar = false
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                Header(
                    showSidebar: $showSidebar,
                    title: Env.router.tab.title
                )
                
                ZStack {
                    VStack {
                        AppTabView(store: store)
                        
                        Spacer()
                        
                        LogView()
                            .environmentObject(store.lift(\.log, AppAction.log))
                            
                    }
                    
                    Sidebar(showSidebar: $showSidebar)
                }
                
            }
            .environmentObject(Env.router)
        }
    }
}


struct AppTabView: View {
    @EnvironmentObject var router: AppRouter
    let store: Store<AppState, AppAction>
    
    var body: some View {
        TabView(selection: $router.tab) {
            ForEach(AppScreen.allCases) { tab in
                tab.createView(store, router)
                    .tag(tab as AppScreen?)
                    .tabItem { tab.label }
                
            }
        }
    }
}


class LogMiddleware {
    func handle(_ state: AppState, _ action: AppAction) -> AnyPublisher<AppAction, Never> {
        let actionStr = "\(action)"
                
        let methods = actionStr.split(separator: "(")
        var methodsFormatted: [String] = []
        for method in methods {
            if(
                method.contains(":") ||
                method.contains("\"") ||
                method.contains("-") ||
                method.contains("[") ||
                method.contains("]")
            ){
                continue // only show action but no data
            }
            
            if let methodFormatted = method.split(separator: ".").last {
                let strMethodFormatted = String(methodFormatted).replacing(")",with: "")
                if(
                    strMethodFormatted.split(separator: " ").count == 1
                ){
                    methodsFormatted.append(strMethodFormatted)
                }
            }
        
        }
        
        var actionFormatted = ""
        for method in methodsFormatted {
            actionFormatted += "." + method
        }
        
        LogService.log(actionFormatted)
        
        return Empty().eraseToAnyPublisher()
    }
}

//
//  businessToGoApp.swift
//  businessToGo
//
//  Created by Admin  on 08.04.24.
//

import SwiftUI

var Env = Environment()

@main
struct businessToGoApp: App {
    let store = AppStore(
        initialState: AppState(),
        reducer: AppState.reduce
    )
    
    
    
    var body: some Scene {
        WindowGroup {
            BusinessToGoView()
                .environmentObject(store)
        }
    }
}

struct BusinessToGoView: View {
    @EnvironmentObject var store: AppStore
    @State var showSidebar = false
    
    var body: some View {
        VStack(spacing: 0) {
            Header(showSidebar: $showSidebar, title: store.state.sceneTitle)
            
            ZStack {
                VStack {
                    AppView()
                        .environmentObject(store.lift(\.scene, AppAction.menu))
                    
                    Spacer()
                    
                    LogView()
                        .environmentObject(store.lift(\.log, AppAction.log))
                }
                
                Sidebar(showSidebar: $showSidebar)
                    .environmentObject(store.lift(\.scene, AppAction.menu))
            }
        }
    }
}

struct AppView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        switch(store.state.scene){
            case .login:
                LoginView()
                    .environmentObject(store.lift(\.login, AppAction.login))
            case .kimai:
                KimaiContainerView()
                    .environmentObject(store.lift(\.kimai, AppAction.kimai))
                    .environmentObject(store.lift(\.taiga, AppAction.taiga))
            
            case .taiga:
                TaigaContainerView()
                    .environmentObject(store.lift(\.kimai, AppAction.kimai))
                    .environmentObject(store.lift(\.taiga, AppAction.taiga))
        case .kimaiSettings:
            KimaiSettingsContainerView()
                .environmentObject(store.lift(\.kimai, AppAction.kimai))
        }
    }
}

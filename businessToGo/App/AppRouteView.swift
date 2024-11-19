import SwiftUI
import Redux

import Intro

extension AppFeature.Route {
    @ViewBuilder func view(_ store: StoreOf<AppFeature>) -> some View {
        switch self {
        case let .settings(route):
            SettingsContainer(store: store.projection(SettingsComponent.self), route: route)
            
        case .intro:
            IntroContainer(store: store.lift(\.intro, AppFeature.Action.intro))
            
        case let .login(route):
            LoginContainer(store: store.projection(LoginComponent.self), route: route)
            
        case let .today(route):
            TodayContainer(store: store.projection(TodayComponent.self), route: route)
            
        case let .management(route):
            ManagementContainer(mainStore: store, route: route)
            
        case let .report(route):
            ReportContainer(store: store.projection(ReportComponent.self), route: route)
        }
    }
}


extension AppFeature.TabRoute {
    @ViewBuilder func label() -> some View {
        switch self {
        case .today:
             Label("Today", systemImage: "clock")
        case .management:
            Label("Projects", systemImage: "square.grid.2x2")
        case .report:
            Label("Reports", systemImage: "chart.bar.xaxis.ascending")
        }
    }
}

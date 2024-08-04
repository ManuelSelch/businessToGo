import SwiftUI
import Redux

import Intro
import LoginApp
import Report
import SettingsApp

extension AppFeature.Route {
    @ViewBuilder func view(_ store: StoreOf<AppFeature>) -> some View {
        switch self {
        case let .settings(route):
            SettingsContainer(store: store.projection(SettingsContainer.self), route: route)
            
        case .intro:
            IntroContainer(store: store.lift(\.intro, AppFeature.Action.intro))
            
        case let .login(route):
            LoginContainer(store: store.lift(\.login, AppFeature.Action.login), route: route)
            
        case let .management(route):
            ManagementContainer(store: store.projection(ManagementContainer.self), route: route)
            
        case let .report(route):
            ReportContainer(store: store.projection(ReportContainer.self), route: route)
        }
    }
}


extension AppFeature.TabRoute {
    @ViewBuilder func label() -> some View {
        switch self {
        case .management:
            Label("Projekte", systemImage: "shippingbox.fill")
        case .report:
            Label("Reports", systemImage: "chart.bar.xaxis.ascending")
        }
    }
}

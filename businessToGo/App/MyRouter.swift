import SwiftUI
import Redux
import Dependencies
import Router

import LoginApp
import Intro

enum TabRoute: Identifiable, Codable, Equatable, Hashable, CaseIterable {
    case today
    case management
    case report
    
    var id: Self {self}
}

enum Route: Identifiable, Codable, Equatable, Hashable {
    case login(LoginFeature.Route)
    case settings(SettingsComponent.Route)
    case intro
    
    case today(TodayComponent.Route)
    case management(ManagementComponent.Route)
    case report(ReportComponent.Route)
    
    var id: Self {self}
}

typealias MyRouter = AppRouter<Route, TabRoute>


extension Route {
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


extension TabRoute {
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

struct RouterKey: DependencyKey {
    static var liveValue: MyRouter = AppRouter(
        root: .login(.accounts),
        tab: .management,
        routers: [
            .today: StackRouter(root: .today(.today)),
            .management: StackRouter(root: .management(.kimai(.customersList))),
            .report: StackRouter(root: .report(.reports))
        ]
    )
    static var mockValue = liveValue
}

extension DependencyValues {
    var router: MyRouter {
        get { Self[RouterKey.self] }
        set { Self[RouterKey.self] = newValue }
    }
}

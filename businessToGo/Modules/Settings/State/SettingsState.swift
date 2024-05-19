import Foundation

struct SettingsState: Codable {
    var routes: [SettingsRoute]
    var sheet: SettingsRoute?
}

struct SettingsDependency {
    
}

extension SettingsState {
    init(){
        routes = []
    }
}

import OfflineSync

struct ManagementState: Equatable, Codable {
    var kimai: KimaiState
    var taiga: TaigaState
    var integrations: [Integration]

    init(){
        kimai = KimaiState()
        taiga = TaigaState()
        integrations = []
    }
}

enum ManagementRoute: Equatable, Hashable, Codable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
}

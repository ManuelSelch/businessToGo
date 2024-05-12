import OfflineSync

struct ManagementState: Equatable {
    var kimai: KimaiState
    var taiga: TaigaState
    var integrations: [Integration]
    var changes: [DatabaseChange]

    init(){
        kimai = KimaiState()
        taiga = TaigaState()
        integrations = []
        changes = []
    }
}

enum ManagementRoute: Equatable, Hashable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
}

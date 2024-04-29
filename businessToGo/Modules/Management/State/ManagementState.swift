struct ManagementState: Equatable {
    var kimai: KimaiState
    var taiga: TaigaState
    var integrations: [Integration]

    init(){
        kimai = KimaiState()
        taiga = TaigaState()
        integrations = []
    }
}

enum ManagementRoute: Equatable, Hashable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
}

struct ManagementState: Equatable {
    var kimai: KimaiState
    var taiga: TaigaState

    init(){
        kimai = KimaiState()
        taiga = TaigaState()
    }
}

enum ManagementRoute: Equatable, Hashable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
}

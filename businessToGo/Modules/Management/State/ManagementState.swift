import OfflineSync

struct ManagementState: Equatable {
    var kimai: KimaiState
    var taiga: TaigaState
    var integrations: [Integration]
    
    var customerChanges: [DatabaseChange]
    var projectChanges: [DatabaseChange]
    var timesheetChanges: [DatabaseChange]

    init(){
        kimai = KimaiState()
        taiga = TaigaState()
        integrations = []
        customerChanges = []
        projectChanges = []
        timesheetChanges = []
    }
}

enum ManagementRoute: Equatable, Hashable {
    case kimai(KimaiRoute)
    case taiga(TaigaScreen)
}

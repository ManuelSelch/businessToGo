import OfflineSync

struct KimaiActivity: TableProtocol {
    var id: Int
    var project: Int?
    var name: String
    var visible: Bool
    var billable: Bool
    var color: String?
}

extension KimaiActivity {
    init(){
        id = -1
        project = 0
        name = ""
        visible = false
        billable = false
        color = ""
    }
    
    static let new = KimaiActivity()
}

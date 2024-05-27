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
        project = nil
        name = ""
        visible = true
        billable = true
        color = nil
    }
    
    static let new = KimaiActivity()
    
    static let sample = Self(
        id: 1,
        name: "Sample Activity",
        visible: true,
        billable: true
    )
}

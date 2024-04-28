struct KimaiActivity: TableProtocol {
    var id: Int
    var project: Int?
    var name: String
    var visible: Bool
    var billable: Bool
    
    init(){
        id = 0
        project = 0
        name = ""
        visible = false
        billable = false
    }
}

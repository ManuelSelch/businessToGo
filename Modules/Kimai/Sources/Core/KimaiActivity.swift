import OfflineSync

public struct KimaiActivity: TableProtocol {
    public var id: Int
    public var project: Int?
    public var name: String
    public var visible: Bool
    public var billable: Bool
    public var color: String?
}

public extension KimaiActivity {
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

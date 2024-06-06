import Foundation
import OfflineSync

public struct Integration: TableProtocol, Hashable {
    public var id: Int // kimaiProjectId
    public var taigaProjectId: Int
    
    public init(_ kimaiProjectId: Int, _ taigaProjectId: Int) {
        self.id = kimaiProjectId
        self.taigaProjectId = taigaProjectId
    }
    
    public init(){
        id = 0
        taigaProjectId = 0
    }
}

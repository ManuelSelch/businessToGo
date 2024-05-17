import Foundation
import OfflineSync

struct Integration: TableProtocol, Equatable, Hashable {
    var id: Int // kimaiProjectId
    var taigaProjectId: Int
    
    init(_ kimaiProjectId: Int, _ taigaProjectId: Int) {
        self.id = kimaiProjectId
        self.taigaProjectId = taigaProjectId
    }
    
    init(){
        id = 0
        taigaProjectId = 0
    }
}

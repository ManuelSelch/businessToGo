import Foundation

struct KimaiTimesheet: TableProtocol {
    var activity: Int
    var project: Int
    // var user: Int
    // var tags: [String]
    var id: Int
    var begin: String
    var end: String?
    // var duration: Int
    
    var description: String?
    /*
    var rate: Double
    var exported: Bool
    var billable: Bool
    */
    
    // var metaFields: [String : String]
    
    init(){
        activity = 0
        project = 0
        // user = 0
        // tags = []
        id = 0
        begin = ""
        end = ""
        description = ""
        
        /*
        duration = 0
        description = ""
        rate = 0
        exported = false
        billable = false
        */
        // metaFields = [:]
    }
    
    init(_ project: Int, _ activity: Int, _ begin: String, _ description: String?){
        self.id = 0
        
        self.project = project
        self.activity = activity
        self.begin = begin
        self.description = description
    }
}

extension KimaiTimesheet {
    static let new = KimaiTimesheet(0, 0, "", "")
}

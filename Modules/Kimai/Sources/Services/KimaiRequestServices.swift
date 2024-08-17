import Dependencies
import OfflineSyncServices
import KimaiCore

struct TimesheetRequestServiceKey: DependencyKey {
    static var liveValue: RequestService<KimaiTimesheet, KimaiAPI> = .live(
        fetchMethod:  {KimaiAPI.getTimesheets(0)},
        insertMethod: KimaiAPI.insertTimesheet,
        updateMethod: KimaiAPI.updateTimesheet,
        deleteMethod: KimaiAPI.deleteTimesheet
    )
    
    static var mockValue: RequestService<KimaiTimesheet, KimaiAPI> = .mock(
        fetchMethod:  {KimaiAPI.getTimesheets(0)},
        insertMethod: KimaiAPI.insertTimesheet,
        updateMethod: KimaiAPI.updateTimesheet,
        deleteMethod: KimaiAPI.deleteTimesheet
    )
}


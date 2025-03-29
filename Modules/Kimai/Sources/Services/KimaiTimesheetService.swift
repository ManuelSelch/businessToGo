import Dependencies
import Moya
import OfflineSyncServices

import KimaiCore

struct KimaiTimesheetService {
    static var live: RecordService<KimaiTimesheet> = .init(
        repository: .init("kimai_timesheets"),
        requestService: PageRequestService.live(
            fetchMethod:  KimaiAPI.getTimesheets,
            insertMethod: KimaiAPI.insertTimesheet,
            updateMethod: KimaiAPI.updateTimesheet,
            deleteMethod: KimaiAPI.deleteTimesheet
        )
        // keyMapping: KeyMappingTable.shared
    )
    static var mock: RecordService<KimaiTimesheet> = .init(
        repository: .init("kimai_timesheets"),
        requestService: PageRequestService.mock(
            fetchMethod:  KimaiAPI.getTimesheets,
            insertMethod: KimaiAPI.insertTimesheet,
            updateMethod: KimaiAPI.updateTimesheet,
            deleteMethod: KimaiAPI.deleteTimesheet
        )
        // keyMapping: KeyMappingTable.shared
    )
}

import Dependencies
import Moya
import OfflineSyncServices

import KimaiCore

struct TimesheetsKey: DependencyKey {
    static var liveValue: RecordService<KimaiTimesheet> = .init(
        repository: .init("kimai_timesheets"),
        requestService: PageRequestService.live(
            fetchMethod:  KimaiAPI.getTimesheets,
            insertMethod: KimaiAPI.insertTimesheet,
            updateMethod: KimaiAPI.updateTimesheet,
            deleteMethod: KimaiAPI.deleteTimesheet
        )
    )
    static var mockValue: RecordService<KimaiTimesheet> = .init(
        repository: .init("kimai_timesheets"),
        requestService: PageRequestService.mock(
            fetchMethod:  KimaiAPI.getTimesheets,
            insertMethod: KimaiAPI.insertTimesheet,
            updateMethod: KimaiAPI.updateTimesheet,
            deleteMethod: KimaiAPI.deleteTimesheet
        )
    )
}


extension DependencyValues {
    var timesheets: RecordService<KimaiTimesheet> {
        get { Self[TimesheetsKey.self] }
        set { Self[TimesheetsKey.self] = newValue }
    }
}

import Dependencies
import OfflineSyncServices

import KimaiCore

struct ActivityKey: DependencyKey {
    static var liveValue: RecordService<KimaiActivity> = .init(
        repository: .init("kimai_activities"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getActivities},
            insertMethod: KimaiAPI.insertActivity,
            updateMethod: KimaiAPI.updateActivity,
            deleteMethod: nil
        )
    )
    static var mockValue: RecordService<KimaiActivity> = .init(
        repository: .init("kimai_activities"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getActivities},
            insertMethod: KimaiAPI.insertActivity,
            updateMethod: KimaiAPI.updateActivity,
            deleteMethod: nil
        )
    )
}


extension DependencyValues {
    var activities: RecordService<KimaiActivity> {
        get { Self[ActivityKey.self] }
        set { Self[ActivityKey.self] = newValue }
    }
}

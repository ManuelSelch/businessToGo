import Dependencies
import OfflineSyncServices

import KimaiCore

struct KimaiActivityService {
    static var live: RecordService<KimaiActivity> = .init(
        repository: .init("kimai_activities"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getActivities},
            insertMethod: KimaiAPI.insertActivity,
            updateMethod: KimaiAPI.updateActivity,
            deleteMethod: nil
        ),
        keyMapping: KeyMappingTable.shared
    )
    static var mock: RecordService<KimaiActivity> = .init(
        repository: .init("kimai_activities"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getActivities},
            insertMethod: KimaiAPI.insertActivity,
            updateMethod: KimaiAPI.updateActivity,
            deleteMethod: nil
        ),
        keyMapping: KeyMappingTable.shared
    )
}

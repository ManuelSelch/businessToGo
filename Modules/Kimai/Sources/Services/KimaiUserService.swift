import Dependencies
import OfflineSyncServices

import KimaiCore

struct KimaiUserService {
    static var live: RecordService<KimaiUser> = .init(
        repository: .init("kimai_users"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getUsers}
        ),
        keyMapping: KeyMappingTable.shared
    )
    static var mock: RecordService<KimaiUser> = .init(
        repository: .init("kimai_users"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getUsers}
        ),
        keyMapping: KeyMappingTable.shared
    )
}
